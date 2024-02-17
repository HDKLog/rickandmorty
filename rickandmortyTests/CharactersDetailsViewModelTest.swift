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
        
    }

    final class Router: CharactersDetailsRouting {

        var goBackCalls: Int = 0
        var goBackClosure: () ->  Void = { }
        func goBack() {
            goBackCalls += 1
            goBackClosure()
        }
        
    }

    var cancellables:[AnyCancellable] = []

    private func makeSut(service: CharactersDetailsServicing, router: CharactersDetailsRouting? = nil, characterId: Int) -> CharactersDetailsViewModel {
        CharactersDetailsViewModel(service: service, router: router, characterId: characterId)
    }

    func test_charactersListViewModel_onViewAppear_loadsCharacterOnce() {
        let service = Service()
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        sut.onViewAppear()

        XCTAssertEqual(service.getsCharacterCalls, 1)
    }

    func test_charactersListViewModel_onViewAppear_loadsCharacterWithCorrectId() {
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

    func test_charactersListViewModel_onViewAppear_setCharacterDataToViewState() {
        let service = Service()
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.character, .mock)
    }

    func test_charactersListViewModel_onViewAppear_setCorrectViewState() {
        let service = Service()
        let characterId: Int = 0
        let sut = makeSut(service: service, characterId: characterId)

        service.getsCharacterClosure = {_ in
            Just(CharactersListPage.Character.mock).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.$viewState.sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.onViewAppear()
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.viewState.viewState, .characterLoaded(.mock))
    }

    func test_charactersListViewModel_onGoBack_navigatesBackOnce() {
        let service = Service()
        let router = Router()
        let characterId: Int = 0
        let sut = makeSut(service: service, router: router, characterId: characterId)

        sut.onGoBack()

        XCTAssertEqual(router.goBackCalls, 1)
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
                                     origin: CharactersListPage.Character.Origin(name: "Earth (C-137)",
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
