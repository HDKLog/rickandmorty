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
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    default:
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                }
                VStack(spacing: 30) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.viewState.character.name)
                                .font(.largeTitle)
                            Spacer()
                            HStack {
                                Text(viewModel.viewState.character.status)
                                Text("-")
                                Text(viewModel.viewState.character.species)
                                Spacer()
                            }
                        }
                        // Display detailed character information
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Last known location:")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.viewState.character.location)
                            Spacer()
                        }
                        Spacer()
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("First seen in:")
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
                    Text("Episodes:")
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    LazyVStack {
                        ForEach(viewModel.viewState.character.episode) { episode in
                            Text("\(episode.id)")
                        }
                    }
                }
            }
            .padding(30)
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .navigationBarTitle("Character Details")
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
                Text("Go back")
            }
        }
    }
}

#Preview {
    CharactersDetailsView(viewModel: CharactersDetailsViewModel(service: Service(), characterId: 1))
}
