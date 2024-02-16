import Foundation
import Combine

public protocol CharactersListServicing {
    func getsCharactersListPage(page: Int) -> AnyPublisher<CharactersListPage, Error>
}
