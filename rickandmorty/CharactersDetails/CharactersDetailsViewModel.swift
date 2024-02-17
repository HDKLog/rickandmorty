import Foundation
import Combine

protocol CharactersDetailsViewModeling: ObservableObject {
    var viewState: CharactersDetailsViewState { get }

    func onViewAppear()
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
        loadCharacter()
    }

    private func loadCharacter() {
        service
            .getsCharacter(characterId: characterId)
            .catch { error in
                print("Service error: \(error)")
                return Empty<CharactersListPage.Character, Never>(completeImmediately: true).eraseToAnyPublisher()
            }
            .compactMap { [weak self] character in
                self?.viewState.withState(newViewState: .characterLoaded(character.viewStateCharacter))
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
