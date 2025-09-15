import Foundation
import Combine

@testable import rickandmorty

class ServiceMock: Servicing {

    var getsCharactersListPageCalls: Int = 0
    var getsCharactersListPageClosure: (Int, CharactersListFilter?) -> AnyPublisher<CharactersListPage, any Error> = { _, _ in
        Empty<CharactersListPage, any Error>().eraseToAnyPublisher()
    }
    func getsCharactersListPage(page: Int, filter: CharactersListFilter?) -> AnyPublisher<CharactersListPage, any Error> {
        getsCharactersListPageCalls += 1
        return getsCharactersListPageClosure(page, filter)
    }

    var getsCharacterCalls: Int = 0
    var getsCharacterClosure: (Int) -> AnyPublisher<CharactersListPage.Character, any Error> = { _ in
        Empty<CharactersListPage.Character, any Error>().eraseToAnyPublisher()
    }
    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, any Error> {
        getsCharacterCalls += 1
        return getsCharacterClosure(characterId)
    }

    var getEpisodesCalls: Int = 0
    var getEpisodesClosure: ([Int]) -> AnyPublisher<[EpisodesListPage.Episode], any Error> = {_ in
        Empty<[EpisodesListPage.Episode], any Error>().eraseToAnyPublisher()
    }
    func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], any Error> {
        getEpisodesCalls += 1
        return getEpisodesClosure(episodesIds)
    }

    var cachedImageCalls: Int = 0
    var cachedImageClosure: (URL) -> URL? = { _ in nil }
    func cachedImage(from url: URL) -> URL? {
        cachedImageCalls += 1
        return cachedImageClosure(url)
    }
    
    
}

