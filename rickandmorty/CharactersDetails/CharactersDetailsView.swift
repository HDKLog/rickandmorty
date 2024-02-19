import SwiftUI

struct CharactersDetailsView<T: CharactersDetailsViewModeling>: View {
    @ObservedObject var viewModel: T

    var body: some View {
        ScrollView (.vertical) {
            VStack {
                AsyncImage(url: URL(string: viewModel.viewState.character.image)) { phase in

                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: DesigneBook.Design.Size.Frame.Width.large, height: DesigneBook.Design.Size.Frame.Height.large)
                            .clipShape(RoundedRectangle(cornerRadius: DesigneBook.Design.Size.CornerRadius.medium))
                    default:
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: DesigneBook.Design.Size.Frame.Width.large, height: DesigneBook.Design.Size.Frame.Height.large)
                            .clipShape(RoundedRectangle(cornerRadius: DesigneBook.Design.Size.CornerRadius.medium))
                    }
                }
                VStack(spacing: DesigneBook.Design.Spacing.small) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.viewState.character.name)
                                .font(.largeTitle)
                            Spacer()
                            HStack {
                                Text(String(
                                    format: DesigneBook.Text.CharactersDetails.Character.statusSpeciesFormat,
                                    viewModel.viewState.character.status,
                                    viewModel.viewState.character.species
                                ))
                                Spacer()
                            }
                        }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(DesigneBook.Text.CharactersDetails.Character.lastLocationLabel)
                                .font(.headline)
                            Spacer()
                            Text(viewModel.viewState.character.location)
                            Spacer()
                        }
                        Spacer()
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(DesigneBook.Text.CharactersDetails.Character.originLabel)
                                .font(.headline)
                            Spacer()
                            Text(viewModel.viewState.character.origin)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                Spacer()
                HStack {
                    Text(DesigneBook.Text.CharactersDetails.Character.episodesLabel)
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
            .padding(DesigneBook.Design.Padding.extraLarge)
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .navigationBarTitle(DesigneBook.Text.CharactersDetails.Navigation.title)
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
                Text(DesigneBook.Text.CharactersDetails.Navigation.backButtonLabel)
            }
        }
    }
}

#Preview {
    CharactersDetailsView(viewModel: CharactersDetailsViewModel(service: Service(), characterId: 1))
}
