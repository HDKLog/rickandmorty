import Foundation
import Combine

public protocol CharactersListServicing {
    func getsCharactersListPage(page: Int, filter: CharactersListFilter?) -> AnyPublisher<CharactersListPage, Error>
}

final class CharactersListService: CharactersListServicing {

    let service: Servicing

    init(service: Servicing) {
        self.service = service
    }

    func getsCharactersListPage(page: Int, filter: CharactersListFilter?) -> AnyPublisher<CharactersListPage, Error> {
        service.getsCharactersListPage(page: page, filter: filter)
    }
}
