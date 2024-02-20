import SwiftUI

struct RouterView: View {
    enum NavigationEndpoint: Hashable {
        case list
        case charactersDetails(Int)
    }

    @State var endpoint: [NavigationEndpoint] = []

    private var service: ServiceSelector = ServiceSelector()

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
        case .charactersDetails(let id):
            CharactersDetailsView(viewModel: CharactersDetailsViewModel(service: service, router: self, characterId: id))
        }
    }
}
extension RouterView: CharactersListRouting, CharactersDetailsRouting {

    public func goBack() {
        self.endpoint.removeLast()
    }
    public func routeToCharacterDetails(id: Int) {
        self.endpoint.append(.charactersDetails(id))
    }

}
