import SwiftUI


struct EpisodeSectionView: View {
    let episode: CharactersDetailsViewState.Episode
    let onCharacterImageTap: ((Int) -> Void)?

    var body: some View {
        DisclosureGroup() {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(episode.characters) { character in
                        EpisodeCharacterView(character: character).onTapGesture {
                            onCharacterImageTap?(character.id)
                        }
                    }
                }
            }
        } label: {
            Text(episode.name)
                .multilineTextAlignment(.leading)
                .font(.title2)
                .padding(DesigneBook.Design.Padding.extraSmall)
        }
        .tint(DesigneBook.Design.Color.Foreground.highlited.swiftUIColor())
        .padding(DesigneBook.Design.Padding.medium)
    }
    
    init(episode: CharactersDetailsViewState.Episode, onCharacterImageTap: ( (Int) -> Void)? = nil) {
        self.episode = episode
        self.onCharacterImageTap = onCharacterImageTap
    }
}

#Preview {
    VStack {
        EpisodeSectionView(episode: .init(id: 1, 
                                          name: "Close Rick-counters of the Rick Kind",
                                          characters: [
                                            .init(
                                                id: 1,
                                                url: URL(string: "https://rickandmortyapi.com/api/character/1")!,
                                                image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
                                            ),
                                            .init(
                                                id: 2,
                                                url: URL(string: "https://rickandmortyapi.com/api/character/2")!,
                                                image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
                                            )
                                          ]))
    }.border(.black)
}
