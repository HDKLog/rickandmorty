import Foundation
import Combine
import CoreData

protocol CachingService {

    func cacheCharacters(charactters: [CharactersListPage.Character])
    func cacheEpisodes(episodes: [EpisodesListPage.Episode])
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
        .map { records in
            CharactersListPage(from: records)
        }
        .eraseToAnyPublisher()
    }

    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error> {
        Just(context).tryCompactMap { context in

            let fetchRequest = CharacterRecord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld && created != nil ", characterId as CVarArg)
            return try context.fetch(fetchRequest).first
        }
        .map { records in
            CharactersListPage.Character(from: records)
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

extension OfflineService: CachingService {
    func cacheCharacters(charactters: [CharactersListPage.Character]) {
        let context = self.context
        let fetchRequest = CharacterRecord.fetchRequest()


        for character in charactters {
            fetchRequest.predicate = NSPredicate(format: "id == %lld", character.id as CVarArg)
            let characterRecord = (try? context.fetch(fetchRequest).first) ?? CharacterRecord(context: context)

            characterRecord.id = Int64(character.id)
            characterRecord.name = character.name
            characterRecord.status = character.status
            characterRecord.species = character.species
            characterRecord.type = character.type
            characterRecord.gender = character.gender

            if let originUrl = URL(string: character.origin.url),
               let originId = Int(originUrl.lastPathComponent) {
                let originRequest = LocationRecord.fetchRequest()
                originRequest.predicate = NSPredicate(format: "id == %lld", originId as CVarArg)
                let origin = (try? context.fetch(originRequest).first) ?? LocationRecord(context: context)
                origin.id = Int64(originId)
                origin.name = character.origin.name
                origin.url = character.origin.url
                characterRecord.origin = origin
            }

            if let locationUrl = URL(string: character.location.url),
               let locationId = Int(locationUrl.lastPathComponent) {
                let locationRequest = LocationRecord.fetchRequest()
                locationRequest.predicate = NSPredicate(format: "id == %lld", locationId as CVarArg)
                let location = (try? context.fetch(locationRequest).first) ?? LocationRecord(context: context)
                location.id = Int64(locationId)
                location.name = character.location.name
                location.url = character.location.url
                characterRecord.location = location
            }
            characterRecord.image = character.image

            for episodeUrlString in character.episode {

                if let episodeUrl = URL(string: episodeUrlString),
                   let episodeId = Int(episodeUrl.lastPathComponent) {
                    let episodeRequest = EpisodeRecord.fetchRequest()
                    episodeRequest.predicate = NSPredicate(format: "id == %lld", episodeId as CVarArg)
                    let episode = (try? context.fetch(episodeRequest).first) ?? EpisodeRecord(context: context)
                    episode.id = Int64(episodeId)
                    characterRecord.addToEpisode(episode)
                }

            }
            characterRecord.url = character.url
            characterRecord.created = character.created

        }

        do {
            try context.save()
        } catch {
            print("Character saving error")
        }

    }
    
    func cacheEpisodes(episodes: [EpisodesListPage.Episode]) {

        let context = self.context
        let fetchRequest = EpisodeRecord.fetchRequest()

        for episode in episodes {
            fetchRequest.predicate = NSPredicate(format: "id == %lld", episode.id as CVarArg)
            let episodeRecord = (try? context.fetch(fetchRequest).first) ?? EpisodeRecord(context: context)

            episodeRecord.id = Int64(episode.id)
            episodeRecord.name = episode.name
            episodeRecord.air_date = episode.air_date
            episodeRecord.episode = episode.episode

            for characterUrlString in episode.characters {
                if let characterUrl = URL(string: characterUrlString),
                   let characterId = Int(characterUrl.lastPathComponent) {
                    let characterRequest = CharacterRecord.fetchRequest()
                    characterRequest.predicate = NSPredicate(format: "id == %lld", characterId as CVarArg)
                    let character = (try? context.fetch(characterRequest).first) ?? CharacterRecord(context: context)
                    character.id = Int64(characterId)
                    character.addToEpisode(episodeRecord)
                }
            }

            episodeRecord.url = episode.url
            episodeRecord.created = episode.name
        }

        try? context.save()
    }

}

extension CharactersListPage {

    init(from characters: [CharacterRecord]) {

        info = Info(count: characters.count, pages: 1, next: nil, prev: nil)
        results = characters.map { CharactersListPage.Character(from: $0) }
    }
}

extension CharactersListPage.Character {

    init(from character: CharacterRecord) {
        id = Int(character.id)
        name = character.name ?? ""
        status = character.status ?? ""
        species = character.species ?? ""
        type = character.type ?? ""
        gender = character.gender ?? ""
        origin = Location(name: character.origin?.name ?? "", url: character.origin?.url ?? "")
        location = Location(name: character.location?.name ?? "", url: character.location?.url ?? "")
        image = character.image ?? ""

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
