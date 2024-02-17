import Foundation
import Combine

protocol CharactersDetailsServicing {
    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error>
}
