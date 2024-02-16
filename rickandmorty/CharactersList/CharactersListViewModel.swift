import Foundation
import Combine

protocol CharactersListViewModeling: ObservableObject {
    var viewState: CharactersListViewState { get }

    func onViewAppear()
}

final class CharactersListViewModel: CharactersListViewModeling {

    @Published var viewState: CharactersListViewState = CharactersListViewState()

    private let service: CharactersListServicing
    private let router: CharactersListRouting?
    private var page: Int = 1

    init(service: CharactersListServicing, router: CharactersListRouting? = nil) {
        self.service = service
        self.router = router
    }

    func onViewAppear() {
        loadNextPage()
    }

    func loadNextPage() {
        service
            .getsCharactersListPage(page: page)
            .catch{ error in
                print("Service error: \(error)")
                return Empty<CharactersListPage, Never>(completeImmediately: true).eraseToAnyPublisher()
            }
            .compactMap { [weak self] listPage in
                self?.page += listPage.info.next != nil ? 1 : 0
                return self?.viewState.withState(newViewState: .loaded(listPage.viewStateCharacters))
            }
            .assign(to: &$viewState)
    }
}

extension CharactersListPage {
    var viewStateCharacters: [CharactersListViewState.Character] {
        results.map { character in
            CharactersListViewState.Character(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                image: URL(string: character.image)
            )
        }
    }
}
