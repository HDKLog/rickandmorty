import SwiftUI

protocol RoutingViewFactoring {

    associatedtype RoutingView: View
    @ViewBuilder func view(for endpoint: RouterViewState.NavigationEndpoint) -> RoutingView

    associatedtype RootView: View
    func rootView() -> RootView
}

class RoutingViewFactory<T: RoutingViewModelFactoring>: RoutingViewFactoring {

    let viewModelFactory: T

    init(viewModelFactory: T) {
        self.viewModelFactory = viewModelFactory
    }

    func view(for endpoint: RouterViewState.NavigationEndpoint) -> some View {
        switch endpoint {
        case .list:
            CharactersListView(viewModel: viewModelFactory.listViewModeling())
        case .charactersDetails(let id):
            CharactersDetailsView(viewModel: viewModelFactory.detailsViewModel(characterId: id))
        }
    }

    func rootView() -> some View {
        RouterView(viewModel: viewModelFactory.rootViewModel, viewFactory: self)
    }
}
