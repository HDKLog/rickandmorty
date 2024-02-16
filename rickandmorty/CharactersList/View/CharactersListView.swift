import SwiftUI

struct CharactersListView<T: CharactersListViewModeling>: View {
    @ObservedObject var viewModel: T

    var body: some View {
        List {
            Section(header:header, footer: footer) {
                ForEach(viewModel.viewState.characters) { character in
                    CharactersListRow(
                        characterName: character.name,
                        characterImage: character.image
                    ).onAppear {
                        viewModel.onCharacterAppear(id: character.id)
                    }
                }
            }

        }
        .listStyle(.plain)
        .navigationBarTitle("Characters")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform:viewModel.onViewAppear)
    }

    var header: some View {
        VStack {}
    }

    var footer: some View {
        VStack {}
    }
}

#Preview {
    CharactersListView(viewModel: CharactersListViewModel(service: Service()))
}
