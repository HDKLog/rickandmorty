import Foundation

protocol CharactersDetailsRouting {
    func goBack()
    func routeToCharacterDetails(id: Int)
}

final class CharactersDetailsRouter: CharactersDetailsRouting {

    private let navigationRouter: NavigationRouting?

    init(navigationRouter: NavigationRouting?) {
        self.navigationRouter = navigationRouter
    }

    func goBack() {
        navigationRouter?.popLast()
    }
    func routeToCharacterDetails(id: Int) {
        navigationRouter?.push(endpoint: .charactersDetails(id))
    }
}
