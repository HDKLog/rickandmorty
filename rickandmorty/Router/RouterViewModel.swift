import Foundation

protocol RouterViewModeling: CharactersListRouting, CharactersDetailsRouting, ObservableObject {
    var viewState: RouterViewState { get set }
    var service: ServiceSelector { get }
}

class RouterViewModel: RouterViewModeling {

    @Published var viewState: RouterViewState = RouterViewState()

    var service: ServiceSelector = ServiceSelector()

    init() {
    }



    public func goBack() {
        viewState.endpoint.removeLast()
    }
    public func routeToCharacterDetails(id: Int) {
        viewState.endpoint.append(.charactersDetails(id))
    }

}
