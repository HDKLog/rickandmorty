import Foundation
import Combine

protocol CharactersListViewModeling: ObservableObject {
    var viewState: CharactersListViewState { get set }

    func onViewAppear()
    func onCharacterAppear(id: Int)
    func onCharacterTap(id: Int)
    func onSearch()
    func onErrorDismiss()
}

final class CharactersListViewModel: CharactersListViewModeling {

    @Published var viewState: CharactersListViewState = CharactersListViewState()

    private let service: CharactersListServicing
    private let router: CharactersListRouting?
    private var currentPageInfo: CharactersListPage.Info? = nil
    private var nextPage: Int = 1
    private var searchFilter: CharactersListFilter?

    init(service: CharactersListServicing, router: CharactersListRouting? = nil) {
        self.service = service
        self.router = router
    }

    func onViewAppear() {
        loadNextPage()
    }

    func onCharacterAppear(id: Int) {
        guard viewState.characters.last?.id == id,
              currentPageInfo?.next != nil
        else { return }
        
        loadNextPage()

    }

    func onCharacterTap(id: Int) {
        router?.routeToCharacterDetails(id: id)
    }

    func onSearch() {
        searchFilter = CharactersListFilter(name: viewState.searchText,
                                            status: viewState.selectedStatus,
                                            gender: viewState.selectedGender)
        resetLoadedResults()
    }

    func onErrorDismiss() {
        viewState = viewState.withState(newViewState: .dismissError)
    }

    private func resetLoadedResults() {
        nextPage = 1
        viewState = viewState.withState(newViewState: .initial)
        loadNextPage()
    }

    private func loadNextPage() {
        viewState = viewState.withState(newViewState: .loading)
        service
            .getsCharactersListPage(page: nextPage, filter: searchFilter)
            .catch{ [weak self] error in
                print("Service error: \(error)")
                self?.showError(message: error.localizedDescription)
                return Empty<CharactersListPage, Never>(completeImmediately: true).eraseToAnyPublisher()
            }
            .compactMap { [weak self] listPage in
                self?.currentPageInfo = listPage.info
                self?.nextPage += 1
                return self?.viewState.withState(newViewState: .loaded(listPage.viewStateCharacters))
            }
            .assign(to: &$viewState)
    }

    private func showError(message: String) {
        viewState = viewState.withState(newViewState: .error(message))
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
