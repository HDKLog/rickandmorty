import XCTest
import Combine


@testable import rickandmorty
final class CharactersDetailsViewModelTest: XCTestCase {

    final class Service: CharactersDetailsServicing {

        var getsCharacterCalls: Int = 0
        var getsCharacterClosure: () ->  AnyPublisher<CharactersListPage.Character, Error> = {
            Empty<CharactersListPage.Character, Error>(completeImmediately: true).eraseToAnyPublisher()
        }
        func getsCharacter() -> AnyPublisher<CharactersListPage.Character, Error> {
            getsCharacterCalls += 1
            return getsCharacterClosure()
        }

        var getEpisodesCalls: Int = 0
        var getEpisodesClosure: ([Int]) ->  AnyPublisher<[EpisodesListPage.Episode], Error> = { _ in
            Empty<[EpisodesListPage.Episode], Error>(completeImmediately: true).eraseToAnyPublisher()
        }
        func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], Error> {
            getEpisodesCalls += 1
            return getEpisodesClosure(episodesIds)
        }

        var cachedImageCalls: Int = 0
        var cachedImageClosure: (URL) ->  URL? = { _ in
            nil
        }
        func cachedImage(from url: URL) -> URL? {
            cachedImageCalls += 1
            return cachedImageClosure(url)
        }

    }

    final class Router: CharactersDetailsRouting {

        var goBackCalls: Int = 0
        var goBackClosure: () ->  Void = { }
        func goBack() {
            goBackCalls += 1
            goBackClosure()
        }

        var routeToCharacterDetailsCalls: Int = 0
        var routeToCharacterDetailsClosure: (Int) ->  Void = { _ in }
        func routeToCharacterDetails(id: Int) {
            routeToCharacterDetailsCalls += 1
            routeToCharacterDetailsClosure(id)
        }

    }

    var cancellables:[AnyCancellable] = []

    private func makeSut(service: CharactersDetailsServicing, router: CharactersDetailsRouting? = nil) -> CharactersDetailsViewModel {
        CharactersDetailsViewModel(service: service, router: router)
    }

    func test_charactersDetailsViewModel_onViewAppear_loadsCharacterOnce() {
        let service = Service()
        let sut = makeSut(service: service)

        sut.onViewAppear()

        XCTAssertEqual(service.getsCharacterCalls, 1)
    }

    func test_charactersDetailsViewModel_onViewAppear_setsCharacterDataToViewState() {
        let service = Service()
        let sut = makeSut(service: service)

        service.getsCharacterClosure = {
            Just(CharactersListPage.Character.mockRick).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst().sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.character, .mockRick)
    }

    func test_charactersDetailsViewModel_onViewAppear_setsCorrectViewState() {
        let service = Service()
        let sut = makeSut(service: service)

        service.getsCharacterClosure = {
            Just(CharactersListPage.Character.mockRick).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst().sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.viewState, .characterLoaded(.mockRick))
    }

    func test_charactersDetailsViewModel_onViewAppear_whenCharacterLoadingErrorOccurs_setsErrorInViewState() {

        let error = NSError(domain: "Error", code: -1)
        let service = Service()

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharacterClosure = {
            Fail<CharactersListPage.Character, Error>(error: error).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst().sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(sut.viewState.viewState, .error(error.localizedDescription))
    }

    func test_charactersDetailsViewModel_onViewAppear_loadsEpisodesOnce() {
        let service = Service()
        let sut = makeSut(service: service)

        service.getsCharacterClosure = {
            Just(CharactersListPage.Character.mockRick).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        service.getEpisodesClosure = {_ in
            Just(EpisodesListPage.mock.results).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst(2).sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(service.getEpisodesCalls, 1)
    }

    func test_charactersDetailsViewModel_onViewAppear_setsEpisodesDataToViewState() {
        let service = Service()
        let sut = makeSut(service: service)

        service.getsCharacterClosure = {
            Just(CharactersListPage.Character.mockRick).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        service.getEpisodesClosure = {_ in
            Just(EpisodesListPage.mock.results).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst(2).sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.episodes, [.mockE1, .mockE2])
    }

    func test_charactersDetailsViewModel_onViewAppear_whenLoadsEpisodes_requestCachedCharactersImagesOnce() {
        let service = Service()
        let episode = EpisodesListPage.mock.results.first!
        let sut = makeSut(service: service)

        service.getsCharacterClosure = {
            Just(CharactersListPage.Character.mockRick).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        service.getEpisodesClosure = {_ in
            Just([episode]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst(2).sink { state in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(service.cachedImageCalls, episode.characters.count)
    }

    func test_charactersDetailsViewModel_onViewAppear_whenLoadsEpisodes_setsCachedCharactersImagesForViewStateEpisode() {
        let service = Service()
        let episode = EpisodesListPage.mock.results.first!
        let cachedEpisodeCharacterUrl = URL(string: "google.com")
        let sut = makeSut(service: service)

        service.getsCharacterClosure = {
            Just(CharactersListPage.Character.mockRick).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        service.getEpisodesClosure = {_ in
            Just([episode]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        service.cachedImageClosure = {_ in
            cachedEpisodeCharacterUrl
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst(2).sink { state in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.episodes.first?.characters.first?.image, cachedEpisodeCharacterUrl)
    }

    func test_charactersDetailsViewModel_onViewAppear_whenEpisodesLoaded_setsCorrectViewState() {
        let service = Service()
        let sut = makeSut(service: service)

        service.getsCharacterClosure = {
            Just(CharactersListPage.Character.mockRick).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        service.getEpisodesClosure = {_ in
            Just(EpisodesListPage.mock.results).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst(2).sink { state in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.viewState, .episodesLoaded([.mockE1, .mockE2]))
    }

    func test_charactersDetailsViewModel_onViewAppear_whenEpisodesLoadingErrorOccurs_setsErrorInViewState() {

        let error = NSError(domain: "Error", code: -1)
        let service = Service()

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharacterClosure = {
            Just(CharactersListPage.Character.mockRick).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        service.getEpisodesClosure = {_ in
            Fail<[EpisodesListPage.Episode], Error>(error: error).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service)

        sut.$viewState.dropFirst(2).sink {_ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout:2)

        XCTAssertEqual(sut.viewState.viewState, .error(error.localizedDescription))
    }

    func test_charactersDetailsViewModel_onCharacterTap_navigatesToCharacterDetailsOnce() {
        let tapedCharacterId = 1
        let service = Service()
        let router = Router()
        let sut = makeSut(service: service, router: router)

        sut.onCharacterTap(id: tapedCharacterId)

        XCTAssertEqual(router.routeToCharacterDetailsCalls, 1)
    }

    func test_charactersDetailsViewModel_onCharacterTap_navigatesCorrectCharacterId() {
        let tapedCharacterId = 1
        let service = Service()
        let router = Router()
        let sut = makeSut(service: service, router: router)

        var navigateToId: Int?
        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        router.routeToCharacterDetailsClosure = { characterId in
            navigateToId = characterId
            expectation.fulfill()
        }

        sut.onCharacterTap(id: tapedCharacterId)
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(navigateToId, tapedCharacterId)
    }


    func test_charactersDetailsViewModel_onGoBack_navigatesBackOnce() {
        let service = Service()
        let router = Router()
        let sut = makeSut(service: service, router: router)

        sut.onGoBack()

        XCTAssertEqual(router.goBackCalls, 1)
    }
}
