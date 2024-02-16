import Foundation

struct CharactersListViewState: Hashable {
    enum ViewState: Hashable {
        case initial
        case loading
        case loaded([Character])
    }
    struct Character: Identifiable, Equatable, Hashable {
        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let image: URL?
    }

    var characters: [Character] = []
    var viewState: ViewState = .initial

    mutating func setnewViewState(newViewState: ViewState) {
        viewState = newViewState
        switch viewState {
        case .initial:
            break
        case .loading:
            break
        case .loaded(let newCharacters):
            characters.append(contentsOf: newCharacters)
        }
    }

    func withState(newViewState: ViewState) -> Self {
        var mutation = self
        mutation.setnewViewState(newViewState: newViewState)
        return mutation
    }
}
