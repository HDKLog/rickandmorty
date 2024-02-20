import Foundation
import Combine
import CoreData

protocol CachingService {

    func cacheCharacters(charactters: [CharactersListPage.Character])
    func cacheEpisodes(episodes: [EpisodesListPage.Episode])

    func cachedImage(from url: URL?) -> URL?
}

class OfflineService: CharactersListServicing, CharactersDetailsServicing {

    let pesristentContainerName = "RickAndMortyDataModel"
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.pesristentContainerName)
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext { self.persistentContainer.viewContext }

    var cancellables:[AnyCancellable] = []


    func getsCharactersListPage(page: Int, filter: CharactersListFilter?) -> AnyPublisher<CharactersListPage, Error> {

        Just(context).tryMap { context in
            let request = CharacterRecord.fetchRequest()

            var format = ""
            if let searchName = filter?.name, !searchName.isEmpty {
                format = "\(format) && (name CONTAINS[cd] '\(searchName)')"
            }
            if let searchStatus = filter?.status {
                format = "\(format) && (status LIKE[c] '\(searchStatus)')"
            }
            if let searchGender = filter?.gender {
                format = "\(format) && (gender LIKE[c] '\(searchGender)')"
            }
            request.predicate = NSPredicate(format: "created != nil \(format)")
            return try context.fetch(request)
        }
        .compactMap { [weak self] records in
            guard let self else { return nil }
            return CharactersListPage(from: records, cacher: self)
        }
        .eraseToAnyPublisher()
    }

    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error> {
        Just(context).tryCompactMap { context in

            let fetchRequest = CharacterRecord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld && created != nil ", characterId as CVarArg)
            return try context.fetch(fetchRequest).first
        }
        .compactMap { [weak self] records in
            guard let self else { return nil }
            return CharactersListPage.Character(from: records, cacher: self)
        }
        .eraseToAnyPublisher()
    }

    func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], Error> {
        Just(context).tryMap { context in
            let request = EpisodeRecord.fetchRequest()
            request.predicate = NSPredicate(format: "name != nil && created != nil")
            return try context.fetch(EpisodeRecord.fetchRequest())
        }
        .map { records in
            records.map { EpisodesListPage.Episode(from: $0) }
        }
        .eraseToAnyPublisher()
    }
}



extension CharactersListPage {

    init(from characters: [CharacterRecord], cacher: CachingService) {

        info = Info(count: characters.count, pages: 1, next: nil, prev: nil)
        results = characters.map { CharactersListPage.Character(from: $0, cacher: cacher) }
    }
}

extension CharactersListPage.Character {

    init(from character: CharacterRecord, cacher: CachingService) {
        id = Int(character.id)
        name = character.name ?? ""
        status = character.status ?? ""
        species = character.species ?? ""
        type = character.type ?? ""
        gender = character.gender ?? ""
        origin = Location(name: character.origin?.name ?? "", url: character.origin?.url ?? "")
        location = Location(name: character.location?.name ?? "", url: character.location?.url ?? "")
        image = character.image.flatMap { cacher.cachedImage(from: URL(string: $0))?.absoluteString } ?? ""

        let episodesSet = character.episode?.compactMap { $0 as? EpisodeRecord }
        let episodesArray = episodesSet?.compactMap {  $0.url }
        episode = episodesArray ?? []

        url = character.url ?? ""
        created = character.created ?? ""
    }
}

extension EpisodesListPage.Episode {
    init(from record: EpisodeRecord) {
        id = Int(record.id)
        name = record.name ?? ""
        air_date = record.air_date ?? ""
        episode = record.episode ?? ""

        let charactersSet = record.characters?.compactMap { $0 as? CharacterRecord }
        let charactersArray = charactersSet?.compactMap {  $0.url }
        characters = charactersArray ?? []

        url = record.url ?? ""
        created = record.created ?? ""
    }
}
