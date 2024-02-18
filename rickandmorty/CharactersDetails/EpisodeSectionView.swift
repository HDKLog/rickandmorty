import SwiftUI


struct EpisodeSectionView: View {
    let episode: CharactersDetailsViewState.Episode

    var body: some View {
        DisclosureGroup() {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(episode.characters) { character in
                        EpisodeCharacterView(character: character)
                    }
                }
            }
        } label: {
            Text(episode.name)
                .multilineTextAlignment(.leading)
                .font(.title2)
                .padding(5)
        }
        .tint(.brown)
        .padding(10)
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
