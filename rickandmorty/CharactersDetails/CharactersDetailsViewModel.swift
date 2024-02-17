import Foundation
import Combine

protocol CharactersDetailsViewModeling: ObservableObject {
    var viewState: CharactersDetailsViewState { get }

    func onViewAppear()
}

final class CharactersDetailsViewModel: CharactersDetailsViewModeling {

    @Published var viewState: CharactersDetailsViewState = CharactersDetailsViewState()

    private let service: CharactersDetailsServicing
    private let router: CharactersDetailsRouting?
    private let characterId: Int

    init(service: CharactersDetailsServicing, router: CharactersDetailsRouting? = nil, characterId: Int) {
        self.service = service
        self.router = router
        self.characterId = characterId
    }

    func onViewAppear() {
    }
}
