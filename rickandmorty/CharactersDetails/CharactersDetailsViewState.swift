import Foundation

struct CharactersDetailsViewState: Hashable {
    enum ViewState: Hashable {
        case initial
        case loading
        case characterLoaded(Character)
        case episodesLoaded([Episode])
        case error(String)
        case dismissError
    }

    struct Character: Identifiable, Equatable, Hashable {
        struct Episode: Identifiable, Equatable, Hashable {
            var id: Int
            let url: URL
        }

        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let origin: String
        let location: String
        let image: String
        let episode: [Episode]
    }

    struct Episode: Identifiable, Equatable, Hashable {
        struct Character: Identifiable, Equatable, Hashable {
            let id: Int
            let url: URL
            let image: URL?
        }

        let id: Int
        let name: String
        var characters: [Character]
    }

    var viewState: ViewState = .initial
    var character: Character = .init(id: 0, name: "", status: "", species: "", type: "", gender: "", origin: "", location: "", image: "", episode: [])
    var episodes: [Episode] = []

    var showError: Bool = false
    var errorMessage: String = ""

    mutating func setnewViewState(newViewState: ViewState) {
        viewState = newViewState
        switch viewState {
        case .initial:
            break
        case .loading:
            break
        case .characterLoaded(let character):
            self.character = character
        case .episodesLoaded(let episodes):
            self.episodes = episodes
        case .error(let errorMessage):
            self.errorMessage = errorMessage
            self.showError = true
        case .dismissError:
            self.showError = false
        }
    }

    func withState(newViewState: ViewState) -> Self {
        var mutation = self
        mutation.setnewViewState(newViewState: newViewState)
        return mutation
    }
}

#if DEBUG

extension CharactersDetailsViewState.Character {
    static var mockRick: CharactersDetailsViewState.Character {
        .init(id: 1,
              name: "Rick Sanchez",
              status: "Alive",
              species: "Human",
              type: "", gender: "Male",
              origin: "Earth (C-137)",
              location: "Citadel of Ricks",
              image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
              episode: [.mock, .mock])
    }
}

extension CharactersDetailsViewState.Character.Episode {
    static var mock: CharactersDetailsViewState.Character.Episode {
        .init(id: 1, url: URL(string: "https://rickandmortyapi.com/api/episode/1")!)
    }
}

extension CharactersDetailsViewState.Episode.Character {
    static var mockRick: CharactersDetailsViewState.Episode.Character {
          .init(
              id: 1,
              url: URL(string: "https://rickandmortyapi.com/api/character/1")!,
              image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
          )
    }

    static var mockMorty: CharactersDetailsViewState.Episode.Character {
        .init(
              id: 2,
              url: URL(string: "https://rickandmortyapi.com/api/character/2")!,
              image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
          )
    }
}

extension CharactersDetailsViewState.Episode {
    static var mockE1: CharactersDetailsViewState.Episode {
        .init(id: 1,
              name: "Pilot",
              characters: [.mockRick, .mockMorty])
    }

    static var mockE2: CharactersDetailsViewState.Episode {
        .init(id: 2,
              name: "Lawnmower Dog",
              characters: [.mockRick, .mockMorty])
    }
}

#endif
