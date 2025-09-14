import Foundation
import Combine
import Network

class ServiceSelector: Servicing {

    let queue = DispatchQueue(label: "NetworkMonitor")
    let monitor = NWPathMonitor()

    var offlineService: OfflineService = { OfflineService() }()
    lazy var onlineService: Service = { Service(cacher: offlineService) }()
    lazy var selectedService: Servicing = onlineService

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Internet connection is available.")
                self?.switchToOnlineService()
            } else {
                print("Internet connection is not available.")
                self?.switchToOfflineService()
            }
        }
        monitor.start(queue: queue)
    }

    private func switchToOnlineService() {
        selectedService = onlineService
    }

    private func switchToOfflineService() {
        selectedService = offlineService
    }

    func getsCharactersListPage(page: Int, filter: CharactersListFilter?) -> AnyPublisher<CharactersListPage, Error> {
        selectedService.getsCharactersListPage(page: page, filter: filter)
    }
    
    func getsCharacter(characterId: Int) -> AnyPublisher<CharactersListPage.Character, Error> {
        selectedService.getsCharacter(characterId: characterId)
    }
    
    func getEpisodes(episodesIds: [Int]) -> AnyPublisher<[EpisodesListPage.Episode], Error> {
        selectedService.getEpisodes(episodesIds: episodesIds)
    }
    
    func cachedImage(from url: URL) -> URL? {
        selectedService.cachedImage(from: url)
    }

}
