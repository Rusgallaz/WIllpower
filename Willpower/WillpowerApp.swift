//
//  WillpowerApp.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 02.06.2021.
//

import SwiftUI

@main
struct WillpowerApp: App {

    @Environment(\.scenePhase) var scenePhase

    @StateObject var timersStorage: TimersStorage
    @StateObject var persistenceController: PersistenceController

    init() {
        let persistenceController = PersistenceController()
        _persistenceController = StateObject(wrappedValue: persistenceController)
        let storage = TimersStorage(managedObjectContext: persistenceController.container.viewContext)
        _timersStorage = StateObject(wrappedValue: storage)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(persistenceController)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
