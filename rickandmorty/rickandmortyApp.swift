import SwiftUI

@main
struct rickandmortyApp: App {


    var routingViewModelFactory: some RoutingViewModelFactoring { RoutingViewModelFactory(service: ServiceSelector()) }
    var viewFactory: some RoutingViewFactoring { RoutingViewFactory(viewModelFactory: routingViewModelFactory) }

    var body: some Scene {
        WindowGroup {
            viewFactory.rootView()
        }
    }
}
