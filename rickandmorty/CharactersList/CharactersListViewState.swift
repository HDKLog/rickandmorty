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

    var selectedStatusKey = "All"
    var selectedStatus: String? { statuses[selectedStatusKey].flatMap { $0?.rawValue } }
    let statuses: [String : Character.Status?] = ["All": .none, "Alive": .alive, "Dead":.dead, "Unknown":.unknown]

    var selectedGenderKey = "Any"
    var selectedGender: String? { genders[selectedGenderKey].flatMap { $0?.rawValue } }
    let genders: [String : Character.Gender?] = ["Any": .none, "Male": .male, "Female":.female, "Genderless": .genderless, "Unknown":.unknown]

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
