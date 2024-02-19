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
