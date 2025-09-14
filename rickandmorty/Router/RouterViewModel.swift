import Foundation

protocol NavigationRouting {
    func popLast()
    func push(endpoint: RouterViewState.NavigationEndpoint)
}

protocol RouterViewModeling: NavigationRouting, ObservableObject {
    var viewState: RouterViewState { get set }
}

class RouterViewModel: RouterViewModeling {

    @Published var viewState: RouterViewState = RouterViewState()

    init() {
    }

    func popLast() {
        viewState.endpoint.removeLast()
    }

    func push(endpoint: RouterViewState.NavigationEndpoint) {
        viewState.endpoint.append(endpoint)
    }

}
