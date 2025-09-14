import SwiftUI

struct RouterView<T: RouterViewModeling, F: RoutingViewFactoring>: View {

    @ObservedObject var viewModel: T

    var viewFactory: F

    var body: some View {
        NavigationStack(path:$viewModel.viewState.endpoint) {
            viewFactory.view(for: .list).navigationDestination(for: RouterViewState.NavigationEndpoint.self) { endpoint in
                viewFactory.view(for: endpoint)
            }
        }
    }
}
