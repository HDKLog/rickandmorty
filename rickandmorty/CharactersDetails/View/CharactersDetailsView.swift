import SwiftUI

struct CharactersDetailsView<T: CharactersDetailsViewModeling>: View {
    @ObservedObject var viewModel: T

    var body: some View {
        ScrollView (.vertical) {
            VStack {
                AdaptiveStack() {
                    VStack {
                        AsyncImage(url: URL(string: viewModel.viewState.character.image)) { phase in

                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: DesignBook.Design.Size.Frame.Width.large, height: DesignBook.Design.Size.Frame.Height.large)
                                    .clipShape(RoundedRectangle(cornerRadius: DesignBook.Design.Size.CornerRadius.medium))
                            default:
                                Image(systemName: "person")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: DesignBook.Design.Size.Frame.Width.large, height: DesignBook.Design.Size.Frame.Height.large)
                                    .clipShape(RoundedRectangle(cornerRadius: DesignBook.Design.Size.CornerRadius.medium))
                            }
                        }
                    }
                    VStack {
                        VStack(spacing: DesignBook.Design.Spacing.small) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(viewModel.viewState.character.name)
                                        .font(.largeTitle)
                                    Spacer()
                                    HStack {
                                        Text(String(
                                            format: DesignBook.Text.CharactersDetails.Character.statusSpeciesFormat,
                                            viewModel.viewState.character.status,
                                            viewModel.viewState.character.species
                                        ))
                                        Spacer()
                                    }
                                }
                            }
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(DesignBook.Text.CharactersDetails.Character.lastLocationLabel)
                                        .font(.headline)
                                    Spacer()
                                    Text(viewModel.viewState.character.location)
                                    Spacer()
                                }
                                Spacer()
                            }
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(DesignBook.Text.CharactersDetails.Character.originLabel)
                                        .font(.headline)
                                    Spacer()
                                    Text(viewModel.viewState.character.origin)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                }

                Spacer()
                HStack {
                    Text(DesignBook.Text.CharactersDetails.Character.episodesLabel)
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    VStack {
                        ForEach(viewModel.viewState.episodes) { episode in
                            EpisodeSectionView(episode: episode) { characterId in
                                viewModel.onCharacterTap(id: characterId)
                            }
                        }
                    }
                }
            }
            .padding(DesignBook.Design.Padding.extraLarge)
        }
        .alert(DesignBook.Text.CharactersList.Error.dialogName,
               isPresented: $viewModel.viewState.showError) {
            VStack {
                Text(viewModel.viewState.errorMessage)
                Button(action: viewModel.onErrorDismiss) {
                    Text(DesignBook.Text.CharactersList.Error.dialogButtonName)
                }
            }
        }
               .scrollIndicators(.hidden)
               .listStyle(.plain)
               .navigationBarTitle(DesignBook.Text.CharactersDetails.Navigation.title)
               .navigationBarTitleDisplayMode(.inline)
               .navigationBarBackButtonHidden()
               .navigationBarItems(leading: btnBack)
               .onAppear(perform:viewModel.onViewAppear)
    }

    var btnBack : some View {
        Button(action:viewModel.onGoBack) {
            HStack {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                Text(DesignBook.Text.CharactersDetails.Navigation.backButtonLabel)
            }
        }
    }
}

#Preview {
    CharactersDetailsView(viewModel: CharactersDetailsViewModel(service: Service(), characterId: 1))
}
