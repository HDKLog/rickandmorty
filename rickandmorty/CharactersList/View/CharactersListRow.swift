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
                        .frame(width: DesignBook.Design.Size.Frame.Width.small, height: DesignBook.Design.Size.Frame.Height.small)
                        .clipShape(Circle())
                default:
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: DesignBook.Design.Size.Frame.Width.small, height: DesignBook.Design.Size.Frame.Height.small)
                        .clipShape(Circle())
                }
            }
            Text(characterName)
                .font(.headline)
                .padding(.trailing, DesignBook.Design.Padding.medium)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}
