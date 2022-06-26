//
//  CoreDataChallenge_v2App.swift
//  CoreDataChallenge_v2
//
//  Created by Eric Di Gioia on 6/1/22.
//

import SwiftUI

@main
struct CoreDataChallenge_v2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
