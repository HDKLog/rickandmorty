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
        .background(DesigneBook.Design.Color.Background.list.swiftUIColor())
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listStyle(.plain)
        .navigationBarTitle(DesigneBook.Text.CharactersList.Navigation.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform:viewModel.onViewAppear)
    }

    var header: some View {
        HStack {
            VStack {
                TextField(DesigneBook.Text.CharactersList.Search.nameFieldPlaceholder, text: $viewModel.viewState.searchText)
                    .padding(DesigneBook.Design.Padding.small)
                    .padding(.horizontal, DesigneBook.Design.Padding.large)
                    .background(DesigneBook.Design.Color.Foreground.light.swiftUIColor())
                    .cornerRadius(DesigneBook.Design.Size.CornerRadius.small)
                    .autocorrectionDisabled()
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(DesigneBook.Text.CharactersList.Search.statusLabel)
                            Picker(DesigneBook.Text.CharactersList.Search.statusPicker, selection: $viewModel.viewState.selectedStatusKey) {
                                ForEach(viewModel.viewState.statuses.keys.sorted(), id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                        HStack {
                            Text(DesigneBook.Text.CharactersList.Search.genderLabel)
                            Picker(DesigneBook.Text.CharactersList.Search.genderPicker, selection: $viewModel.viewState.selectedGenderKey) {
                                ForEach(viewModel.viewState.genders.keys.sorted(), id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                    }
                    Spacer()
                    Button(action: viewModel.onSearch) {
                        Text(DesigneBook.Text.CharactersList.Search.searchButtonLabel)
                    }
                    .buttonStyle(.bordered)
                    .tint(DesigneBook.Design.Color.Foreground.highlited.swiftUIColor())
                }
            }
            .padding()
        }
    }

    var footer: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                if viewModel.viewState.loading {
                    ProgressView()
                }
                Spacer()
            }
            .frame(minHeight: DesigneBook.Design.Size.Frame.Height.medium)
        }
    }
}

#Preview {
    CharactersListView(viewModel: CharactersListViewModel(service: Service()))
}
