import XCTest
import Combine


@testable import rickandmorty
final class CharactersListViewModelTest: XCTestCase {

    final class Service: CharactersListServicing {

        var getsCharactersListPageCalls: Int = 0
        var getsCharactersListPageClosure: (Int) ->  AnyPublisher<CharactersListPage, Error> = { _ in
            Empty<CharactersListPage, Error>(completeImmediately: true).eraseToAnyPublisher()
        }
        func getsCharactersListPage(page: Int) -> AnyPublisher<CharactersListPage, Error> {
            getsCharactersListPageCalls += 1
            return getsCharactersListPageClosure(page)
        }
    }

    final class Router: CharactersListRouting {

    }

    private func makeSut(service: CharactersListServicing, router: CharactersListRouting? = nil) -> CharactersListViewModel {
        CharactersListViewModel(service: service, router: router)
    }

    func test_charactersListViewModel_onViewAppear_loadsNextPageOnce() {

        let service = Service()

        let sut = makeSut(service: service)

        sut.onViewAppear()

        XCTAssertEqual(service.getsCharactersListPageCalls, 1)
    }
}
