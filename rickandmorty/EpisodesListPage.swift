import Foundation

struct EpisodesListPage: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    struct Episode: Codable {
        let id: Int
        let name: String
        let air_date: String
        let episode: String
        let characters: [String]
        let url: String
        let created: String
    }

    let info: Info
    let results: [Episode]

}
