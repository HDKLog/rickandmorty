//
//  EpisodeCharacterView.swift
//  ricknmorty
//
//  Created by Gari Sarkisyan on 11.02.24.
//

import SwiftUI


// Episode Character View
struct EpisodeCharacterView: View {
    let character: CharactersDetailsViewState.Episode.Character

    init(character: CharactersDetailsViewState.Episode.Character) {
        self.character = character
    }

    var body: some View {
        VStack {
            AsyncImage(url: character.image) { phase in
                
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: DesignBook.Design.Size.Frame.Width.medium, height: DesignBook.Design.Size.Frame.Height.medium)
                        .clipShape(Circle())
                default:
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: DesignBook.Design.Size.Frame.Width.medium, height: DesignBook.Design.Size.Frame.Height.medium)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }
}

#Preview {
    VStack {
        EpisodeCharacterView(character: .init(
            id: 1,
            url: URL(string: "https://rickandmortyapi.com/api/character/1")!,
            image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        ))
    }.border(.black)
}
