//
//  Task_UpApp.swift
//  Task Up
//
//  Created by Yashas Kantharaj on 5/7/24.
//

import SwiftUI

@main
struct Task_UpApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
