//
//  AddaptiveView.swift
//  rickandmorty
//
//  Created by Gari Sarkisyan on 20.02.24.
//

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


#Preview {
    AdaptiveStack {
        Text("Element 1")
        Spacer()
        Text("Element 2")
    }
}
