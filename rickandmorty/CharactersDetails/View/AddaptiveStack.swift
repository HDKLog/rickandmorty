//
//  AddaptiveView.swift
//  rickandmorty
//
//  Created by Gari Sarkisyan on 20.02.24.
//

import SwiftUI

struct AddaptiveStack<Content: View>: View {
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
    AddaptiveStack {
        Text("Element 1")
        Spacer()
        Text("Element 2")
    }
}
