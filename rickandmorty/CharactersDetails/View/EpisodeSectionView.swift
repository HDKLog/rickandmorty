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
                .padding(DesignBook.Design.Padding.extraSmall)
        }
        .tint(DesignBook.Design.Color.Foreground.highlighted.swiftUIColor())
        .padding(DesignBook.Design.Padding.medium)
    }
    
    init(episode: CharactersDetailsViewState.Episode, onCharacterImageTap: ( (Int) -> Void)? = nil) {
        self.episode = episode
        self.onCharacterImageTap = onCharacterImageTap
    }
}

#if DEBUG
#Preview {
    VStack {
        EpisodeSectionView(episode: .mockE1)
    }.border(.black)
}
#endif
