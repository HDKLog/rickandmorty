import SwiftUI

struct CharactersListView<T: CharactersListViewModeling>: View {
    @ObservedObject var viewModel: T

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    CharactersListView(viewModel: CharactersListViewModel(service: Service()))
}
