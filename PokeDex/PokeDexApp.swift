//
//  PokeDexApp.swift
//  PokeDex
//
//  Created by Swayam Rustagi on 05/02/24.
//

import SwiftUI

@main
struct PokeDexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
