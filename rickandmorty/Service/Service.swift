import Foundation
import Combine

final class Service: CharactersListServicing, CharactersDetailsServicing {

    let cacher: CachingService?

    private let baseUrl = URL(string: "https://rickandmortyapi.com/api")!
    private lazy var decoder: JSONDecoder = { JSONDecoder() }()

    init(cacher: CachingService? = nil) {
        self.cacher = cacher
    }

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

    public func getsCharactersListPage(page: Int, filter: CharactersListFilter?) -> AnyPublisher<CharactersListPage, Error> {

        let url = baseUrl
            .appendingPathComponent("character")
            .appending(queryItems: [URLQueryItem(name: "page", value: String(page))])
            .appending(queryItems: filter?.asURLQueryItems ?? [])

        return request(url: url)
            .decode(type: CharactersListPage.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { [weak self] page in
                self?.cacher?.cacheCharacters(charactters: page.results)
            })
            .eraseToAnyPublisher()
    }

    public func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error> {
        let url = baseUrl.appendingPathComponent("character").appendingPathComponent("/\(characterId)")
        return request(url: url)
            .decode(type: CharactersListPage.Character.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    public func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], Error> {
        let url = baseUrl.appendingPathComponent("episode").appendingPathComponent("/\(episodesIds.map(String.init).joined(separator: ","))")
        return request(url: url)
            .tryCompactMap { [weak self] data in
                guard let self else { return nil }
                if episodesIds.count > 1 {
                    return try self.decoder.decode([EpisodesListPage.Episode].self, from: data)
                } else {
                    return [try self.decoder.decode(EpisodesListPage.Episode.self, from: data)]
                }
            }
            .handleEvents(receiveOutput: { [weak self] episodes in
                self?.cacher?.cacheEpisodes(episodes: episodes)
            })
            .eraseToAnyPublisher()
    }
}

extension CharactersListFilter {
    var asURLQueryItems: [URLQueryItem] {
        [URLQueryItem(name: "name", value: name),
         URLQueryItem(name: "status", value: status),
         URLQueryItem(name: "gender", value: gender)]
    }
}
