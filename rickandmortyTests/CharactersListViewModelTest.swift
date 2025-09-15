import XCTest
import Combine


@testable import rickandmorty
final class CharactersListViewModelTest: XCTestCase {

    final class Service: CharactersListServicing {

        var getsCharactersListPageCalls: Int = 0
        var getsCharactersListPageClosure: (Int, CharactersListFilter?) ->  AnyPublisher<CharactersListPage, Error> = { _, _ in
            Empty<CharactersListPage, Error>(completeImmediately: true).eraseToAnyPublisher()
        }
        func getsCharactersListPage(page: Int, filter: CharactersListFilter? ) -> AnyPublisher<CharactersListPage, Error> {
            getsCharactersListPageCalls += 1
            return getsCharactersListPageClosure(page, filter)
        }
    }

    final class Router: CharactersListRouting {

        var routeToCharacterDetailsCalls: Int = 0
        var routeToCharacterDetailsClosure: (Int) ->  Void = { _ in }
        func routeToCharacterDetails(id: Int) {
            routeToCharacterDetailsCalls += 1
            routeToCharacterDetailsClosure(id)
        }
    }

    var cancellables:[AnyCancellable] = []

    private func makeSut(service: CharactersListServicing, router: CharactersListRouting? = nil) -> CharactersListViewModel {
        CharactersListViewModel(service: service, router: router)
    }

    func test_charactersListViewModel_onViewAppear_loadsNextPageOnce() {

        let service = Service()

        let sut = makeSut(service: service)

        sut.onViewAppear()

        XCTAssertEqual(service.getsCharactersListPageCalls, 1)
    }

    func test_charactersListViewModel_onViewAppear_setsNextPageDataToViewState() {

        let service = Service()

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Just(CharactersListPage.mockFirst).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(sut.viewState.characters, CharactersListViewState.Character.mocks)
    }

    func test_charactersListViewModel_onViewAppear_setsCorrectViewStateAfterLoad() {

        let service = Service()

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Just(CharactersListPage.mockFirst).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(sut.viewState.viewState, .loaded(CharactersListViewState.Character.mocks))
    }

    func test_charactersListViewModel_onViewAppear_whenLoadingErrorOccurs_setsErrorInViewState() {

        let error = NSError(domain: "Error", code: -1)
        let service = Service()

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Fail<CharactersListPage, Error>(error: error).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(sut.viewState.viewState, .error(error.localizedDescription))
    }

    func test_charactersListViewModel_onCharacterAppear_whenFirstCharacterAppear_doesNotRequestNextPage() {

        let service = Service()
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Just(CharactersListPage.mockFirst).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.first?.id ?? 0)
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(service.getsCharactersListPageCalls, 1)
    }

    func test_charactersListViewModel_onCharacterAppear_whenLastCharacterAppearAndNextPageIsLoading_setsLoadingViewState() {

        let service = Service()
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Just(CharactersListPage.mockFirst)
                .setFailureType(to: Error.self)
                .delay(for: .seconds(3), scheduler: RunLoop.main, options: .none)
                .eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.last?.id ?? 0)

        XCTAssertEqual(sut.viewState.viewState, .loading)
    }

    func test_charactersListViewModel_onCharacterAppear_whenLastCharacterAppearAndNextPageIsLoading_loadingIsTrue() {

        let service = Service()
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Just(CharactersListPage.mockFirst)
                .setFailureType(to: Error.self)
                .delay(for: .seconds(3), scheduler: RunLoop.main, options: .none)
                .eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.last?.id ?? 0)

        XCTAssertTrue(sut.viewState.loading)
    }

    func test_charactersListViewModel_onCharacterAppear_whenFirstCharacterAppearAndNextPageIsLoading_doesNotSetLoadingViewState() {

        let service = Service()
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Just(CharactersListPage.mockFirst).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.first?.id ?? 0)
        wait(for: [expectation], timeout:2)

        XCTAssertNotEqual(sut.viewState.viewState, .loading)
    }

    func test_charactersListViewModel_onCharacterAppear_whenFirstCharacterAppearAndNextPageIsLoading_loadingIsFalse() {

        let service = Service()
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Just(CharactersListPage.mockFirst).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.first?.id ?? 0)
        wait(for: [expectation], timeout:2)

        XCTAssertFalse(sut.viewState.loading)
    }

    func test_charactersListViewModel_onCharacterAppear_whenLastCharacterAppearAndItIsLastPage_doesNotSetLoadingViewState() {

        let service = Service()
        var expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { page, _ in
            Just<CharactersListPage>(page == 1 ? .mockFirst : .mockLast).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)
        expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.last?.id ?? 0)
        wait(for: [expectation], timeout:2)
        sut.onCharacterAppear(id: CharactersListPage.mockLast.viewStateCharacters.last?.id ?? 0)

        XCTAssertNotEqual(sut.viewState.viewState, .loading)
    }

    func test_charactersListViewModel_onCharacterAppear_whenLastCharacterAppearAndItIsLastPage_loadingIsFalse() {

        let service = Service()
        var expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { page, _ in
            Just<CharactersListPage>(page == 1 ? .mockFirst : .mockLast).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)
        expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.last?.id ?? 0)
        wait(for: [expectation], timeout:2)
        sut.onCharacterAppear(id: CharactersListPage.mockLast.viewStateCharacters.last?.id ?? 0)

        XCTAssertFalse(sut.viewState.loading)
    }

    func test_charactersListViewModel_onCharacterAppear_whenLastCharacterAppear_requestsNextPage() {

        let service = Service()
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = {_, _ in
            Just(CharactersListPage.mockFirst).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.last?.id ?? 0)
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(service.getsCharactersListPageCalls, 2)
    }

    func test_charactersListViewModel_onCharacterAppear_whenLastCharacterAppear_requestsNextPageWithCorrectIndex() {

        let service = Service()
        var requestedPages: [Int] = []
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { nextPage, _ in
            requestedPages.append(nextPage)
            return Just(CharactersListPage.mockFirst).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.last?.id ?? 0)
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(requestedPages.last, 2)
    }

    func test_charactersListViewModel_onCharacterAppear_whenLastCharacterAppear_setsCorrectViewStateAfterLoad() {

        let expectedResults: [CharactersListViewState.Character] = CharactersListViewState.Character.mocks + CharactersListViewState.Character.mocks
        let service = Service()
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Just(CharactersListPage.mockFirst).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.last?.id ?? 0)
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(sut.viewState.characters, expectedResults)
    }

    func test_charactersListViewModel_onCharacterAppear_whenLastCharacterAppearAndItIsLastPage_doesNotRequestNextPage() {

        let service = Service()
        var expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { page, _ in
            Just<CharactersListPage>(page == 1 ? .mockFirst : .mockLast).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)
        expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.onCharacterAppear(id: CharactersListPage.mockFirst.viewStateCharacters.last?.id ?? 0)
        wait(for: [expectation], timeout:2)
        sut.onCharacterAppear(id: CharactersListPage.mockLast.viewStateCharacters.last?.id ?? 0)

        XCTAssertEqual(service.getsCharactersListPageCalls, 2)
    }

    func test_charactersListViewModel_onCharacterTap_routesToCharacterDetailsOnce() {

        let service = Service()
        let router = Router()

        let sut = makeSut(service: service, router: router)

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        router.routeToCharacterDetailsClosure = { _ in
            expectation.fulfill()
        }

        sut.onCharacterTap(id: CharactersListPage.mockFirst.viewStateCharacters.first?.id ?? 0)
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(router.routeToCharacterDetailsCalls, 1)
    }

    func test_charactersListViewModel_onCharacterTap_routesToCharacterDetailsWithCorrectId() {

        let service = Service()
        let router = Router()

        var resultId: Int? = nil

        let sut = makeSut(service: service, router: router)

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        router.routeToCharacterDetailsClosure = { characterId in
            resultId = characterId
            expectation.fulfill()
        }

        sut.onCharacterTap(id: CharactersListPage.mockFirst.viewStateCharacters.first?.id ?? 0)
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(resultId, CharactersListPage.mockFirst.viewStateCharacters.first?.id)
    }

    func test_charactersListViewModel_onSearch_loadsNextPageOnce() {

        let service = Service()
        let router = Router()

        let sut = makeSut(service: service, router: router)
        sut.onSearch()

        XCTAssertEqual(service.getsCharactersListPageCalls, 1)
    }

    func test_charactersListViewModel_onSearch_loadsNextPageWithFilter() {

        let service = Service()
        let router = Router()

        let sut = makeSut(service: service, router: router)
        sut.viewState.searchText = "name"
        sut.viewState.selectedStatusKey = sut.viewState.statuses.randomElement()!.key
        sut.viewState.selectedGenderKey = sut.viewState.genders.randomElement()!.key
        let expectingFilter = CharactersListFilter(name: sut.viewState.searchText,
                                                   status: sut.viewState.selectedStatus,
                                                   gender: sut.viewState.selectedGender)

        var requestFilter: CharactersListFilter? = nil
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, filter in
            requestFilter = filter
            expectation.fulfill()
            return Empty<CharactersListPage, Error>(completeImmediately: true).eraseToAnyPublisher()
        }

        sut.onSearch()
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(requestFilter, expectingFilter)
    }

    func test_charactersListViewModel_onErrorDismiss_dismissErrorInViewState() {

        let error = NSError(domain: "Error", code: -1)
        let service = Service()

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharactersListPageClosure = { _, _ in
            Fail<CharactersListPage, Error>(error: error).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        sut.onErrorDismiss()
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(sut.viewState.viewState, .dismissError)
    }

}

extension CharactersListPage.Character {
    static var mocks: [CharactersListPage.Character] {
        [.mockRick, .mockMorty]
    }
}

extension CharactersListViewState.Character {
    static var mocks: [CharactersListViewState.Character] {
        [.mockRick, mockMorty]
    }
}
