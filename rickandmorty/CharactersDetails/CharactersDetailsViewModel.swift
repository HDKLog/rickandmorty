import Foundation
import Combine

protocol CharactersDetailsViewModeling: ObservableObject {
    var viewState: CharactersDetailsViewState { get set }

    func onViewAppear()
    func onGoBack()
    func onCharacterTap(id: Int)
    func onErrorDismiss()
}

final class CharactersDetailsViewModel: CharactersDetailsViewModeling {

    @Published var viewState: CharactersDetailsViewState

    private let service: CharactersDetailsServicing?
    private let router: CharactersDetailsRouting?
    private let characterId: Int

    init(characterId: Int,
         service: CharactersDetailsServicing? = nil,
         router: CharactersDetailsRouting? = nil,
         viewState: CharactersDetailsViewState = CharactersDetailsViewState()) {
        self.service = service
        self.router = router
        self.characterId = characterId
        self.viewState = viewState
    }

    func onViewAppear() {
        setupBindings()
        loadCharacter()
    }

    func onGoBack() {
        router?.goBack()
    }

    public func onCharacterTap(id: Int) {
        router?.routeToCharacterDetails(id: id)
    }

    func onErrorDismiss() {
        viewState = viewState.withState(newViewState: .dismissError)
    }

    private func loadCharacter() {
        service?.getsCharacter(characterId: characterId)
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error in
                print("Service error: \(error)")
                self?.showError(message: error.localizedDescription)
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
            .removeDuplicates()
            .compactMap { [weak self] episodes in
                self?.service?.getEpisodes(episodesIds: episodes.map(\.id))
            }
            .flatMap { $0 }
            .catch { [weak self] error in
                print("Service error: \(error)")
                self?.showError(message: error.localizedDescription)
                return Empty<[EpisodesListPage.Episode], Never>(completeImmediately: true).eraseToAnyPublisher()
            }
            .compactMap { [weak self] episodes in
                guard let self else { return nil }
                return self.viewState.withState(newViewState: .episodesLoaded(self.resolveCacheFor(episodes: episodes)))
            }
            .assign(to: &$viewState)
    }

    private func showError(message: String) {
        viewState = viewState.withState(newViewState: .error(message))
    }

    private func resolveCacheFor(episodes: [EpisodesListPage.Episode]) -> [CharactersDetailsViewState.Episode] {
        episodes.map { episode in

            let characters = episode.characters.compactMap { urlString -> CharactersDetailsViewState.Episode.Character? in
                guard let url = URL(string: urlString ),
                      let id = Int(url.lastPathComponent)
                else {
                    return nil
                }
                let imageUrl = URL(string: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg")
                let resolvedImageUrl = imageUrl.flatMap { [self] url in
                    self.service?.cachedImage(from: url) ?? url
                }
                return CharactersDetailsViewState.Episode.Character(id: id, url: url, image: resolvedImageUrl )
            }
            return CharactersDetailsViewState.Episode(id: episode.id, name: episode.name, characters: characters)
        }
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
