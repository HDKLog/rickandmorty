import Foundation

protocol RoutingViewModelFactoring {

    associatedtype RootViewModel: RouterViewModeling
    var rootViewModel: RootViewModel { get }

    associatedtype ListViewModeling: CharactersListViewModeling
    func listViewModeling() -> ListViewModeling

    associatedtype DetailsViewModeling: CharactersDetailsViewModeling
    func detailsViewModel(characterId: Int) -> DetailsViewModeling
}

final class RoutingViewModelFactory: RoutingViewModelFactoring {

    let service: Servicing

    let rootViewModel = RouterViewModel()

    var navigationRouter: NavigationRouting { rootViewModel }

    init(service: Servicing) {
        self.service = service
    }

    func listViewModeling() -> CharactersListViewModel {
        CharactersListViewModel(service: CharactersListService(service: service),
                                router: CharactersListRouter(navigationRouter: navigationRouter))
    }
    
    func detailsViewModel(characterId: Int) -> CharactersDetailsViewModel {
        CharactersDetailsViewModel(characterId: characterId,
                                   service: CharactersDetailsService(service: service),
                                   router: CharactersDetailsRouter(navigationRouter: navigationRouter))
    }
}
