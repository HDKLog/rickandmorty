import Foundation
import CoreData
import Combine

extension OfflineService: CachingService {
    func cacheCharacters(characters: [CharactersListPage.Character]) {
        let context = self.context
        let fetchRequest = CharacterRecord.fetchRequest()


        for character in characters {
            fetchRequest.predicate = NSPredicate(format: "id == %lld", character.id as CVarArg)
            let characterRecord = (try? context.fetch(fetchRequest).first) ?? CharacterRecord(context: context)

            characterRecord.id = Int64(character.id)
            characterRecord.name = character.name
            characterRecord.status = character.status
            characterRecord.species = character.species
            characterRecord.type = character.type
            characterRecord.gender = character.gender

            if let origin = locationFrom(location: character.origin, in: context) {
                characterRecord.origin = origin
            }

            if let location = locationFrom(location: character.location, in: context) {
                characterRecord.location = location
            }

            characterRecord.image = character.image

            saveImage(url: URL(string: character.image))

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

    private func locationFrom(location: CharactersListPage.Character.Location, in context: NSManagedObjectContext) -> LocationRecord? {
        guard let locationUrl = URL(string: location.url),
              let locationId = Int(locationUrl.lastPathComponent)
        else { return nil }
            let locationRequest = LocationRecord.fetchRequest()
            locationRequest.predicate = NSPredicate(format: "id == %lld", locationId as CVarArg)
            let location = (try? context.fetch(locationRequest).first) ?? LocationRecord(context: context)
            location.id = Int64(locationId)
            location.name = location.name
            location.url = location.url
        return location
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

    func saveImage(url: URL?) {
        if let url {

            let urlPath = url.pathComponents.joined(separator: "_")
            let fileName = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent(urlPath)
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { feed -> Data in
                    guard let response = feed.response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode) else {
                        throw URLError(.badServerResponse)
                    }
                    return feed.data
                }
                .catch { error in
                    print("Service error: \(error)")
                    return Empty<Data, Never>().eraseToAnyPublisher()
                }
                .sink { data in
                    guard let fileUrl = fileName else { return }
                    try? data.write(to: fileUrl)
                    print("Saved")
                }
                .store(in: &cancellables)
        }
    }

    func cachedImage(from url: URL) -> URL? {
        let urlPath = url.pathComponents.joined(separator: "_")
        guard let fileName = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent(urlPath),
              FileManager.default.fileExists(atPath: fileName.path())
        else {
            return nil
        }

        return fileName
    }
}
