import Foundation

@testable import rickandmorty

extension CharactersListPage {
    static var mockFirst: CharactersListPage {
        CharactersListPage(info: .mockFirst, results: CharactersListPage.Character.mocks)
    }
    static var mockLast: CharactersListPage {
        CharactersListPage(info: .mockLast, results: CharactersListPage.Character.mocks)
    }
}

extension CharactersListPage.Character {

    static var mockRick: CharactersListPage.Character {
        CharactersListPage.Character(id: 1,
                                      name: "Rick Sanchez",
                                      status: "Alive",
                                      species: "Human",
                                      type: "",
                                      gender: "Male",
                                      origin: CharactersListPage.Character.Location(name: "Earth (C-137)",
                                                               url: "https://rickandmortyapi.com/api/location/1"),
                                      location: CharactersListPage.Character.Location(name: "Citadel of Ricks",
                                                                   url: "https://rickandmortyapi.com/api/location/3"),
                                      image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                      episode: ["https://rickandmortyapi.com/api/episode/1",
                                                "https://rickandmortyapi.com/api/episode/2",
                                                "https://rickandmortyapi.com/api/episode/3"],
                                      url: "https://rickandmortyapi.com/api/character/1",
                                      created: "2017-11-04T18:48:46.250Z")
    }

    static var mockMorty: CharactersListPage.Character {
        CharactersListPage.Character(id: 2,
                                     name: "Morty Smith",
                                     status: "Alive",
                                     species: "Human",
                                     type: "",
                                     gender: "Male",
                                     origin: CharactersListPage.Character.Location(name: "unknown", url: ""),
                                     location: CharactersListPage.Character.Location(name: "Citadel of Ricks",
                                                                                     url: "https://rickandmortyapi.com/api/location/3"),
                                     image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                                     episode: ["https://rickandmortyapi.com/api/episode/1",
                                               "https://rickandmortyapi.com/api/episode/2",
                                               "https://rickandmortyapi.com/api/episode/3" ],
                                     url: "https://rickandmortyapi.com/api/character/2",
                                     created: "2017-11-04T18:50:21.651Z")
    }
}

extension CharactersListPage.Info {
    static var mockFirst: CharactersListPage.Info {
        CharactersListPage.Info(count: 2, pages: 2, next: "https://rickandmortyapi.com/api/character?page=2", prev: nil)
    }

    static var mockLast: CharactersListPage.Info {
        CharactersListPage.Info(count: 2, pages: 2, next: nil, prev: "https://rickandmortyapi.com/api/character?page=2")
    }
}
