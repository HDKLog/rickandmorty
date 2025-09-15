import XCTest

@testable import rickandmorty

final class CharactersDetailsRouterTest: XCTestCase {

    private func makeSut(navigationRouter: (any NavigationRouting)?) -> CharactersDetailsRouter {
        CharactersDetailsRouter(navigationRouter: navigationRouter)
    }

    func test_charactersDetailsRouter_onGoBack_popsLastView() {

        let navigationRouter = NavigationRouterMock()
        let sut = makeSut(navigationRouter: navigationRouter)

        sut.goBack()

        XCTAssertEqual(navigationRouter.popLastCalls, 1)
    }

    func test_charactersDetailsRouter_onRouteToCharacterDetails_routesToCharacterDetailsView() {

        let characterId: Int = 1
        var routedCharacterId: Int?
        let navigationRouter = NavigationRouterMock()

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")

        navigationRouter.pushClosure = { endpoint in
            if case .charactersDetails(let id) = endpoint {
                routedCharacterId = id
            }
            expectation.fulfill()
        }

        let sut = makeSut(navigationRouter: navigationRouter)

        sut.routeToCharacterDetails(id: characterId)

        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(navigationRouter.pushCalls, 1)
        XCTAssertEqual(routedCharacterId, characterId)
    }
}
