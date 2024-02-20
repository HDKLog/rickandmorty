import Foundation


struct RouterViewState {
    enum NavigationEndpoint: Hashable {
        case list
        case charactersDetails(Int)
    }

    var endpoint: [NavigationEndpoint] = []
}
