import SwiftUI

struct RouterView<T:RouterViewModeling>: View {

    @ObservedObject var viewModel: T

    var body: some View {
        NavigationStack(path:$viewModel.viewState.endpoint) {
            makeView(for: .list).navigationDestination(for: RouterViewState.NavigationEndpoint.self) { endpoint in
                makeView(for: endpoint)
            }
        }
    }

    @ViewBuilder func makeView(for endpoint: RouterViewState.NavigationEndpoint) -> some View {
        switch endpoint {
        case .list:
            CharactersListView(viewModel: CharactersListViewModel(service: viewModel.service, router: viewModel))
        case .charactersDetails(let id):
            CharactersDetailsView(viewModel: CharactersDetailsViewModel(characterId: id, service: viewModel.service, router: viewModel))
        }
    }
}
