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
                    ).onTapGesture {
                        viewModel.onCharacterTap(id: character.id)
                    }
                    .onAppear {
                        viewModel.onCharacterAppear(id: character.id)
                    }
                }
            }
        }
        .alert(item: $viewModel.viewState.error) { error in
            Alert(title: Text(error.title),
                  message: Text(error.message),
                  dismissButton: .cancel(Text(DesignBook.Text.CharactersList.Error.dialogButtonName)))
        }
        .background(DesignBook.Design.Color.Background.list.swiftUIColor())
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listStyle(.plain)
        .navigationBarTitle(DesignBook.Text.CharactersList.Navigation.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform:viewModel.onViewAppear)
        
    }

    @ViewBuilder
    var header: some View {
        HStack {
            VStack {
                TextField(DesignBook.Text.CharactersList.Search.nameFieldPlaceholder, text: $viewModel.viewState.searchText)
                    .padding(DesignBook.Design.Padding.small)
                    .padding(.horizontal, DesignBook.Design.Padding.large)
                    .background(DesignBook.Design.Color.Foreground.light.swiftUIColor())
                    .cornerRadius(DesignBook.Design.Size.CornerRadius.small)
                    .autocorrectionDisabled()
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(DesignBook.Text.CharactersList.Search.statusLabel)
                            Picker(DesignBook.Text.CharactersList.Search.statusPicker, selection: $viewModel.viewState.selectedStatusKey) {
                                ForEach(viewModel.viewState.statuses.keys.sorted(), id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                        HStack {
                            Text(DesignBook.Text.CharactersList.Search.genderLabel)
                            Picker(DesignBook.Text.CharactersList.Search.genderPicker, selection: $viewModel.viewState.selectedGenderKey) {
                                ForEach(viewModel.viewState.genders.keys.sorted(), id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                    }
                    Spacer()
                    Button(action: viewModel.onSearch) {
                        Text(DesignBook.Text.CharactersList.Search.searchButtonLabel)
                    }
                    .buttonStyle(.bordered)
                    .tint(DesignBook.Design.Color.Foreground.highlighted.swiftUIColor())
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    var footer: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                if viewModel.viewState.loading {
                    ProgressView()
                }
                Spacer()
            }
            .frame(minHeight: DesignBook.Design.Size.Frame.Height.medium)
        }
    }
}

#if DEBUG
#Preview("loading") {
    CharactersListView(viewModel: CharactersListViewModel(viewState: CharactersListViewState().withState(newViewState: .loading)))
}

#Preview("loaded") {
    CharactersListView(viewModel: CharactersListViewModel(viewState: CharactersListViewState().withState(newViewState: .loaded([.mockRick, .mockMorty]))))
}

#Preview("Error") {
    CharactersListView(viewModel: CharactersListViewModel(viewState: CharactersListViewState().withState(newViewState: .error("Error descrybing text"))))
}
#endif
