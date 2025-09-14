import Foundation

protocol CharactersListRouting {
    func routeToCharacterDetails(id: Int)
}

final class CharactersListRouter: CharactersListRouting {
    let navigationRouter: NavigationRouting

    init(navigationRouter: NavigationRouting) {
        self.navigationRouter = navigationRouter
    }

    func routeToCharacterDetails(id: Int) {
        navigationRouter.push(endpoint: .charactersDetails(id))
    }
}
