import Foundation
import Combine

protocol CharactersDetailsServicing {
    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error>
    func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], Error>
    func cachedImage(from url: URL) -> URL?
}

final class CharactersDetailsService: CharactersDetailsServicing {

    let service: Servicing

    init(service: Servicing) {
        self.service = service
    }

    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error> {
        service.getsCharacter(characterId: characterId)
    }

    func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], Error> {
        service.getEpisodes(episodesIds: episodesIds)
    }

    func cachedImage(from url: URL) -> URL? {
        service.cachedImage(from: url)
    }
}
