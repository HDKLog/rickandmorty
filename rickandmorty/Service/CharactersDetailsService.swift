import Foundation
import Combine

protocol CharactersDetailsServicing {
    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error>
    func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], Error>
    func cachedImage(from url: URL) -> URL?
}
