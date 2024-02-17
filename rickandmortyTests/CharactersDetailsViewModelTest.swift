import XCTest
import Combine


@testable import rickandmorty
final class CharactersDetailsViewModelTest: XCTestCase {

    final class Service: CharactersDetailsServicing {
    }

    final class Router: CharactersDetailsRouting {
    }

    var cancellables:[AnyCancellable] = []

    private func makeSut(service: CharactersDetailsServicing, router: CharactersDetailsRouting? = nil, characterId: Int) -> CharactersDetailsViewModel {
        CharactersDetailsViewModel(service: service, router: router, characterId: characterId)
    }

    func test_charactersListViewModel_onViewAppear_loadsNextPageOnce() {
    }
}
