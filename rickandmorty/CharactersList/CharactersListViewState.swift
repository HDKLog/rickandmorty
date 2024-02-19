import Foundation

struct CharactersListViewState: Hashable {
    enum ViewState: Hashable {
        case initial
        case loading
        case loaded([Character])
    }
    struct Character: Identifiable, Equatable, Hashable {
        enum Status: String {
            case alive
            case dead
            case unknown
        }

        enum Gender: String {
            case female
            case male
            case genderless
            case unknown
        }

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
    
    var loading: Bool { viewState == .loading }

    var searchText: String = ""

    var selectedStatusKey = DesigneBook.Text.CharactersList.Search.statusPickAll
    var selectedStatus: String? { statuses[selectedStatusKey].flatMap { $0?.rawValue } }
    let statuses: [String : Character.Status?] = [DesigneBook.Text.CharactersList.Search.statusPickAll: .none,
                                                  DesigneBook.Text.CharactersList.Search.statusPickAlive: .alive,
                                                  DesigneBook.Text.CharactersList.Search.statusPickDead:.dead,
                                                  DesigneBook.Text.CharactersList.Search.statusPickUnknown:.unknown]

    var selectedGenderKey = DesigneBook.Text.CharactersList.Search.genderPickAny
    var selectedGender: String? { genders[selectedGenderKey].flatMap { $0?.rawValue } }
    let genders: [String : Character.Gender?] = [DesigneBook.Text.CharactersList.Search.genderPickAny: .none,
                                                 DesigneBook.Text.CharactersList.Search.genderPickMale: .male,
                                                 DesigneBook.Text.CharactersList.Search.genderPickFemale:.female,
                                                 DesigneBook.Text.CharactersList.Search.genderPickGenderless: .genderless,
                                                 DesigneBook.Text.CharactersList.Search.genderPickUnknown:.unknown]

    mutating func setnewViewState(newViewState: ViewState) {
        viewState = newViewState
        switch viewState {
        case .initial:
            characters = []
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
