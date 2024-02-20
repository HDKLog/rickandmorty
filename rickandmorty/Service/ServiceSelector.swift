import Foundation
import Combine
import Network

class ServiceSelector: CharactersListServicing, CharactersDetailsServicing {

    let monitor = NWPathMonitor()

    var offlineService: OfflineService = { OfflineService() }()
    lazy var onlineService: Service = { Service(cacher: offlineService) }()
    lazy var selectedCharactersListService: CharactersListServicing = onlineService
    lazy var selectedCharactersDetailsService: CharactersDetailsServicing = onlineService

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            if path.status == .satisfied {
                print("Internet connection is available.")
                self.selectedCharactersListService = self.onlineService
                self.selectedCharactersDetailsService = self.onlineService
            } else {
                print("Internet connection is not available.")
                self.selectedCharactersListService = self.offlineService
                self.selectedCharactersDetailsService = self.offlineService
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func getsCharactersListPage(page: Int, filter: CharactersListFilter?) -> AnyPublisher<CharactersListPage, Error> {
        selectedCharactersListService.getsCharactersListPage(page: page, filter: filter)
    }
    
    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error> {
        selectedCharactersDetailsService.getsCharacter(characterId: characterId)
    }
    
    func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], Error> {
        selectedCharactersDetailsService.getEpisodes(episodesIds: episodesIds)
    }
    

}
