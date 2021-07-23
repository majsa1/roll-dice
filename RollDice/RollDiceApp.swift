//
//  RollDiceApp.swift
//  RollDice
//
//  Created by Marjo Salo on 12/07/2021.
//

import SwiftUI

@main
struct RollDiceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
