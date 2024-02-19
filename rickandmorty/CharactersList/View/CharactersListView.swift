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
        .listStyle(.plain)
        .navigationBarTitle("Characters")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform:viewModel.onViewAppear)
    }

    var header: some View {
        VStack {
            TextField("Name", text: $viewModel.viewState.searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(uiColor: .init(white: 0, alpha: 0.1)))
                .cornerRadius(8)
                .autocorrectionDisabled()
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Status:")
                        Spacer()
                        Picker("Status", selection: $viewModel.viewState.selectedStatusKey) {
                            ForEach(viewModel.viewState.statuses.keys.sorted(), id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    HStack {
                        Text("Gender:")
                        Spacer()
                        Picker("Status", selection: $viewModel.viewState.selectedGenderKey) {
                            ForEach(viewModel.viewState.genders.keys.sorted(), id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
                Spacer()
                Button(action: viewModel.onSearch) {
                    Text("Search")
                }
                .buttonStyle(.bordered)
                .tint(.black)
            }
        }
        .padding()
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
            .frame(minHeight: 100)
        }
    }
}

#Preview {
    CharactersListView(viewModel: CharactersListViewModel(service: Service()))
}
