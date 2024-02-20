//
//  rickandmortyApp.swift
//  rickandmorty
//
//  Created by Gari Sarkisyan on 16.02.24.
//

import SwiftUI

@main
 struct rickandmortyApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView(viewModel: RouterViewModel())
        }
    }
}
