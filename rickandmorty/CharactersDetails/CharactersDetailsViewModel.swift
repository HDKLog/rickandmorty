import Foundation
import Combine

protocol CharactersDetailsViewModeling: ObservableObject {
    var viewState: CharactersDetailsViewState { get }

    func onViewAppear()
    func onGoBack()
}

final class CharactersDetailsViewModel: CharactersDetailsViewModeling {

    @Published var viewState: CharactersDetailsViewState = CharactersDetailsViewState()

    private let service: CharactersDetailsServicing
    private let router: CharactersDetailsRouting?
    private let characterId: Int

    init(service: CharactersDetailsServicing, router: CharactersDetailsRouting? = nil, characterId: Int) {
        self.service = service
        self.router = router
        self.characterId = characterId
    }

    func onViewAppear() {
        setupBindings()
        loadCharacter()
    }

    func onGoBack() {
        router?.goBack()
    }

    private func loadCharacter() {
        service
            .getsCharacter(characterId: characterId)
            .receive(on: DispatchQueue.main)
            .catch { error in
                print("Service error: \(error)")
                return Empty<CharactersListPage.Character, Never>(completeImmediately: true).eraseToAnyPublisher()
            }
            .compactMap { [weak self] character in
                self?.viewState.withState(newViewState: .characterLoaded(character.viewStateCharacter))
            }
            .assign(to: &$viewState)
    }

    private func setupBindings() {
        $viewState
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .map(\.character.episode)
            .filter { episodes in
                !episodes.isEmpty
            }
            .compactMap { [weak self] episodes in
                self?.service.getEpisodes(episodesIds: episodes.map(\.id))
            }
            .flatMap { $0 }
            .catch { error in
                print("Service error: \(error)")
                return Empty<[EpisodesListPage.Episode], Never>(completeImmediately: true).eraseToAnyPublisher()
            }
            .compactMap { [weak self] episodes in
                self?.viewState.withState(newViewState: .episodesLoaded(episodes.map(\.viewStateEpisode)))
            }
            .assign(to: &$viewState)
    }
}

extension CharactersListPage.Character {
    var viewStateCharacter: CharactersDetailsViewState.Character {
        CharactersDetailsViewState.Character(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            origin: origin.name,
            location: location.name,
            image: image,
            episode: episode.compactMap { urlString in
                guard let url = URL(string: urlString ),
                      let id = Int(url.lastPathComponent)
                else {
                    return nil
                }
                return CharactersDetailsViewState.Character.Episode(id: id, url: url)
            }
        )
    }
}

extension EpisodesListPage.Episode {
    var viewStateEpisode: CharactersDetailsViewState.Episode {
        CharactersDetailsViewState.Episode(id: id, name: name, characters: characters.compactMap({ urlString in
            guard let url = URL(string: urlString ),
                  let id = Int(url.lastPathComponent)
            else {
                return nil
            }
            return CharactersDetailsViewState.Episode.Character(id: id, url: url, image: URL(string: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg") )
        }))
    }
}
