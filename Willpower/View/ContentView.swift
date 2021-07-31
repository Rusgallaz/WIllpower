//
//  ContentView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 02.06.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isCreatingTimer = false

    private var addTimerButton: some View {
        Button(action: {
            isCreatingTimer = true
        }) {
            Image(systemName: "plus").font(.title2)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.WPBackground.edgesIgnoringSafeArea(.all)
                TimersListView()
            }
            .navigationBarTitle("Timers")
            .navigationBarItems(trailing: addTimerButton)
        }
        .sheet(isPresented: $isCreatingTimer) {
            AddTimerView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
