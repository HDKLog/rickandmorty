import Foundation
import Combine

public struct CharactersListFilter: Equatable {
    let name: String?
    let status: String?
    let gender: String?
}

public protocol CharactersListServicing {
    func getsCharactersListPage(page: Int, filter: CharactersListFilter?) -> AnyPublisher<CharactersListPage, Error>
}
