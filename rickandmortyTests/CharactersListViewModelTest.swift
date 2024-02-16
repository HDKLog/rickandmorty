import XCTest


@testable import rickandmorty
final class CharactersListViewModelTest: XCTestCase {

    final class Service: CharactersListServicing {

    }

    final class Router: CharactersListRouting {

    }

    private func makeSut(service: CharactersListServicing, router: CharactersListRouting? = nil) -> CharactersListViewModel {
        CharactersListViewModel(service: service, router: router)
    }

}
