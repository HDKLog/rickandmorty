import Foundation

protocol CharactersListViewModeling: ObservableObject {
    var viewState: CharactersListViewState { get }
}

final class CharactersListViewModel: CharactersListViewModeling {

    @Published var viewState: CharactersListViewState = CharactersListViewState()

    private let service: CharactersListServicing
    private let router: CharactersListRouting?

    init(service: CharactersListServicing, router: CharactersListRouting? = nil) {
        self.service = service
        self.router = router
    }


    
}
