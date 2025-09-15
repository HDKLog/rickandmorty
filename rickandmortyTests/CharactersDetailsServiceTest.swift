import XCTest
import Combine

@testable import rickandmorty

final class CharactersDetailsServiceTest: XCTestCase {

    private func makeSut(characterId: Int = 1, service: ServiceMock = ServiceMock() ) -> CharactersDetailsService {
        CharactersDetailsService(service: service, characterId: characterId)
    }

    func test_charactersDetailsService_fetchesCharacter_onGetsCharacterCall() {
        let characterId: Int = 1
        let mockedCharacter = CharactersListPage.Character.mockRick
        var receivedCharacter: CharactersListPage.Character?
        let service = ServiceMock()
        let sut = makeSut(characterId: characterId, service: service)

        service.getsCharacterClosure = { _ in
            Just<CharactersListPage.Character>(mockedCharacter).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")

        _ = sut.getsCharacter().catch { _ in
            Empty<CharactersListPage.Character, Never>().eraseToAnyPublisher()
        }.sink { character in
            receivedCharacter = character
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(service.getsCharacterCalls, 1)
        XCTAssertEqual(receivedCharacter, mockedCharacter)
    }

}
