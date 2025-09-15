import Foundation

@testable import rickandmorty

final class NavigationRouterMock: NavigationRouting {
    
    var popLastCalls: Int = 0
    var popLastClosure: () -> Void = { }
    func popLast() {
        popLastCalls += 1
        popLastClosure()
    }

    var pushCalls: Int = 0
    var pushClosure: (RouterViewState.NavigationEndpoint) -> Void = { _ in }
    func push(endpoint: RouterViewState.NavigationEndpoint) {
        pushCalls += 1
        pushClosure(endpoint)
    }
}

