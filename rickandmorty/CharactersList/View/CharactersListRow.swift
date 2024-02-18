import SwiftUI

struct CharactersListRow: View {
    let characterName: String
    let characterImage: URL?

    var body: some View {
        HStack {
            // Display character image
            AsyncImage(url: characterImage) { phase in
                switch phase {
                case .success(let image):
                         image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                default:
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            }
            Text(characterName)
                .font(.headline)
                .padding(.trailing, 10.0)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}
