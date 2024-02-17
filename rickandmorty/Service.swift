import Foundation
import Combine

final class Service: CharactersListServicing, CharactersDetailsServicing {


    private var baseUrl = URL(string: "https://rickandmortyapi.com/api")!

    private func request(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for:  url)
        .receive(on: DispatchQueue.main)
        .tryMap { feed in
            guard let response = feed.response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                throw URLError(.badServerResponse)
            }
            return feed.data
        }.eraseToAnyPublisher()
    }

    public func getsCharactersListPage(page: Int) -> AnyPublisher<CharactersListPage, Error> {

        let url = baseUrl.appendingPathComponent("character").appending(queryItems: [URLQueryItem(name: "page", value: String(page))])
        return request(url: url)
            .decode(type: CharactersListPage.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    public func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error> {
        let url = baseUrl.appendingPathComponent("character").appendingPathComponent("/\(characterId)")
        return request(url: url)
            .decode(type: CharactersListPage.Character.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
