import SwiftUI

struct AdaptiveStack<Content: View>: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?

    @ViewBuilder let content: () -> Content

    var body: some View {
        if verticalSizeClass == .compact {
            HStack(content: content)
        } else {
            VStack(content: content)
        }
    }
}


#if DEBUG
#Preview {
    AdaptiveStack {
        Text("Element 1")
        Spacer()
        Text("Element 2")
    }
}
#endif
