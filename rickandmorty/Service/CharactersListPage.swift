import Foundation

public struct CharactersListPage: Codable, Equatable {
    struct Info: Codable, Equatable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    struct Character: Codable, Equatable {
        struct Location: Codable, Equatable {
            let name: String
            let url: String
        }

        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let origin: Location
        let location: Location
        let image: String
        let episode: [String]
        let url: String
        let created: String
    }

    let info: Info
    let results: [Character]
}
