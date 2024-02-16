import SwiftUI

struct RouterView: View {
    enum NavigationEndpoint: Hashable {
        case list
    }

    @State var endpoint: [NavigationEndpoint] = []

    private var service: Service = { Service() }()

    var body: some View {
        NavigationStack(path:$endpoint) {
            makeView(for: .list).navigationDestination(for: NavigationEndpoint.self) { endpoint in
                makeView(for: endpoint)
            }
        }
    }

    @ViewBuilder func makeView(for endpoint: NavigationEndpoint) -> some View {
        switch endpoint {
        case .list:
            CharactersListView(viewModel: CharactersListViewModel(service: service, router: self))
        }
    }
}
extension RouterView: CharactersListRouting {

    func goBack() {
        self.endpoint.removeLast()
    }

}
