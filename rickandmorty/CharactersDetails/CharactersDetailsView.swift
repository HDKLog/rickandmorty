import SwiftUI

struct CharactersDetailsView<T: CharactersDetailsViewModeling>: View {
    @ObservedObject var viewModel: T

    var body: some View {
        VStack {
            

        }
        .listStyle(.plain)
        .navigationBarTitle("Character Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform:viewModel.onViewAppear)
    }
}

#Preview {
    CharactersDetailsView(viewModel: CharactersDetailsViewModel(service: Service(), characterId: 1))
}
