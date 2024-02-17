//
//  FoodieApp.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI

@main
struct FoodieApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
