import Foundation

struct CharactersDetailsViewState: Hashable {
    enum ViewState: Hashable {
        case initial
        case loading
    }

    var viewState: ViewState = .initial

    mutating func setnewViewState(newViewState: ViewState) {
        viewState = newViewState
        switch viewState {
        case .initial:
            break
        case .loading:
            break
        }
    }

    func withState(newViewState: ViewState) -> Self {
        var mutation = self
        mutation.setnewViewState(newViewState: newViewState)
        return mutation
    }
}
