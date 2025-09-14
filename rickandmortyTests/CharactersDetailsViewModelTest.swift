import XCTest
import Combine


@testable import rickandmorty
final class CharactersDetailsViewModelTest: XCTestCase {

    final class Service: CharactersDetailsServicing {

        var getsCharacterCalls: Int = 0
        var getsCharacterClosure: (Int) ->  AnyPublisher<CharactersListPage.Character, Error> = { _ in
            Empty<CharactersListPage.Character, Error>(completeImmediately: true).eraseToAnyPublisher()
        }
        func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error> {
            getsCharacterCalls += 1
            return getsCharacterClosure(characterId)
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

    private func makeSut(service: CharactersDetailsServicing, router: CharactersDetailsRouting? = nil, characterId: Int) -> CharactersDetailsViewModel {
        CharactersDetailsViewModel(characterId: characterId, service: service, router: router)
    }

    func test_charactersDetailsViewModel_onViewAppear_loadsCharacterOnce() {
        let service = Service()
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        sut.onViewAppear()

        XCTAssertEqual(service.getsCharacterCalls, 1)
    }

    func test_charactersDetailsViewModel_onViewAppear_loadsCharacterWithCorrectId() {
        let service = Service()
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        var requestedId: Int? = nil
        service.getsCharacterClosure = {id in
            requestedId = id
            return Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(requestedId, characterId)
    }

    func test_charactersDetailsViewModel_onViewAppear_setsCharacterDataToViewState() {
        let service = Service()
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst().sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.character, .mock)
    }

    func test_charactersDetailsViewModel_onViewAppear_setsCorrectViewState() {
        let service = Service()
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.dropFirst().sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.viewState, .characterLoaded(.mock))
    }

    func test_charactersDetailsViewModel_onViewAppear_whenCharacterLoadingErrorOccurs_setsErrorInViewState() {

        let error = NSError(domain: "Error", code: -1)
        let service = Service()
        let characterId: Int = 0

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharacterClosure = { _ in
            Fail<CharactersListPage.Character, Error>(error: error).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service, characterId: characterId)

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
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
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
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
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

        XCTAssertEqual(sut.viewState.episodes, CharactersDetailsViewState.Episode.mocks)
    }

    func test_charactersDetailsViewModel_onViewAppear_whenLoadsEpisodes_requestCachedCharactersImagesOnce() {
        let service = Service()
        let episode = EpisodesListPage.mock.results.first!
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
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
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
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
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
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

        XCTAssertEqual(sut.viewState.viewState, .episodesLoaded(CharactersDetailsViewState.Episode.mocks))
    }

    func test_charactersDetailsViewModel_onViewAppear_whenEpisodesLoadingErrorOccurs_setsErrorInViewState() {

        let error = NSError(domain: "Error", code: -1)
        let service = Service()
        let characterId: Int = 0

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        service.getEpisodesClosure = {_ in
            Fail<[EpisodesListPage.Episode], Error>(error: error).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service, characterId: characterId)

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
        let characterId: Int = 0
        let sut = makeSut(service: service, router: router, characterId: characterId)

        sut.onCharacterTap(id: tapedCharacterId)

        XCTAssertEqual(router.routeToCharacterDetailsCalls, 1)
    }

    func test_charactersDetailsViewModel_onCharacterTap_navigatesCorrectCharacterId() {
        let tapedCharacterId = 1
        let service = Service()
        let router = Router()
        let characterId: Int = 0
        let sut = makeSut(service: service, router: router, characterId: characterId)

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
        let characterId: Int = 0
        let sut = makeSut(service: service, router: router, characterId: characterId)

        sut.onGoBack()

        XCTAssertEqual(router.goBackCalls, 1)
    }

    func test_charactersDetailsViewModel_onErrorDismiss_dismissErrorInViewState() {

        let error = NSError(domain: "Error", code: -1)
        let service = Service()
        let characterId: Int = 0

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        service.getsCharacterClosure = { _ in
            Fail<CharactersListPage.Character, Error>(error: error).eraseToAnyPublisher()
        }

        let sut = makeSut(service: service, characterId: characterId)

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
    static var mock: CharactersListPage.Character {
        CharactersListPage.Character(id: 1,
                                     name: "Rick Sanchez",
                                     status: "Alive",
                                     species: "Human",
                                     type: "",
                                     gender: "Male",
                                     origin: CharactersListPage.Character.Location(name: "Earth (C-137)",
                                                                                   url: "https://rickandmortyapi.com/api/location/1"),
                                     location: CharactersListPage.Character.Location(name: "Citadel of Ricks",
                                                                                     url: "https://rickandmortyapi.com/api/location/3"),
                                     image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                     episode: ["https://rickandmortyapi.com/api/episode/1",
                                               "https://rickandmortyapi.com/api/episode/2",
                                               "https://rickandmortyapi.com/api/episode/3"],
                                     url: "https://rickandmortyapi.com/api/character/1",
                                     created: "2017-11-04T18:48:46.250Z")
    }
}

extension EpisodesListPage {
    static var mock: EpisodesListPage {
        EpisodesListPage(info: Info(count: 1, pages: 1, next: nil, prev: nil),
                         results: [Episode(id: 1, name: "Pilot", air_date: "December 2, 2013", episode: "S01E01",
                                           characters: ["https://rickandmortyapi.com/api/character/1",
                                                        "https://rickandmortyapi.com/api/character/2"],
                                           url: "https://rickandmortyapi.com/api/episode/1", created: "2017-11-10T12:56:33.798Z"),
                                   Episode(id: 2, name: "Lawnmower Dog", air_date: "December 9, 2013", episode: "S01E02",
                                                     characters: ["https://rickandmortyapi.com/api/character/1",
                                                                  "https://rickandmortyapi.com/api/character/2"],
                                           url: "https://rickandmortyapi.com/api/episode/2", created: "2017-11-10T12:56:33.916Z"),
                                   Episode(id: 3, name: "Anatomy Park", air_date: "December 16, 2013", episode: "S01E03",
                                                     characters: ["https://rickandmortyapi.com/api/character/1",
                                                                  "https://rickandmortyapi.com/api/character/2"],
                                           url: "https://rickandmortyapi.com/api/episode/3",
                                           created: "2017-11-10T12:56:34.022Z")])
    }
}

extension CharactersDetailsViewState.Character {
    static var mock: CharactersDetailsViewState.Character {
        CharactersDetailsViewState.Character(id: 1,
                                     name: "Rick Sanchez",
                                     status: "Alive",
                                     species: "Human",
                                     type: "",
                                     gender: "Male",
                                     origin: "Earth (C-137)",
                                     location: "Citadel of Ricks",
                                     image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                             episode: [ .init(id: 1, url: URL(string: "https://rickandmortyapi.com/api/episode/1")!),
                                                        .init(id: 2, url: URL(string: "https://rickandmortyapi.com/api/episode/2")!),
                                                        .init(id: 3, url: URL(string: "https://rickandmortyapi.com/api/episode/3")!)])
    }
}

extension CharactersDetailsViewState.Episode {
    static var mocks: [CharactersDetailsViewState.Episode] {
        [CharactersDetailsViewState.Episode(id: 1, name: "Pilot", characters: [
            CharactersDetailsViewState.Episode.Character(id: 1,
                      url: URL(string: "https://rickandmortyapi.com/api/character/1")!,
                      image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")),
            CharactersDetailsViewState.Episode.Character(id: 2,
                      url: URL(string: "https://rickandmortyapi.com/api/character/2")!,
                      image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"))
        ]),
         CharactersDetailsViewState.Episode(id: 2, name: "Lawnmower Dog", characters: [
            CharactersDetailsViewState.Episode.Character(id: 1,
                       url: URL(string: "https://rickandmortyapi.com/api/character/1")!,
                       image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")),
            CharactersDetailsViewState.Episode.Character(id: 2,
                       url: URL(string: "https://rickandmortyapi.com/api/character/2")!,
                       image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"))
         ]),
         CharactersDetailsViewState.Episode(id: 3, name: "Anatomy Park", characters: [
            CharactersDetailsViewState.Episode.Character(id: 1,
                       url: URL(string: "https://rickandmortyapi.com/api/character/1")!,
                       image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")),
             Character(id: 2,
                       url: URL(string: "https://rickandmortyapi.com/api/character/2")!,
                       image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"))
         ])]
    }
}
