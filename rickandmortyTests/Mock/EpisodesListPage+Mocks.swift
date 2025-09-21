import Foundation

@testable import rickandmorty

extension EpisodesListPage {
    static var mock: EpisodesListPage {
        EpisodesListPage(info: Info(count: 1, pages: 1, next: nil, prev: nil),
                         results: [Episode(id: 1, name: "Pilot", air_date: "December 2, 2013", episode: "S01E01",
                                           characters: ["https://rickandmortyapi.com/api/character/1",
                                                        "https://rickandmortyapi.com/api/character/2"],
                                           url: "https://rickandmortyapi.com/api/episode/1", created: "2017-11-10T12:56:33.798Z"),
                                   Episode(id: 2, name: "Lawnmower Dog", air_date: "December 9, 2013", episode: "S01E02",
                                                     characters: ["https://rickandmortyapi.com/api/character/1",
                                                                  "https://rickandmortyapi.com/api/character/2"],
                                           url: "https://rickandmortyapi.com/api/episode/2", created: "2017-11-10T12:56:33.916Z")])
    }
}
