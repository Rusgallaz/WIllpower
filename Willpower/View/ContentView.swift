//
//  ContentView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 02.06.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var controller: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var isCreatingTimer = false
    
    @FetchRequest(
        entity: WPTimer.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WPTimer.isActive, ascending: false), NSSortDescriptor(keyPath: \WPTimer.startDate, ascending: true)]
    )
    var timers: FetchedResults<WPTimer>

    var body: some View {
        NavigationView {
            List {
                ForEach(timers) { timer in
                    ZStack {
                        TimerView(timer: timer)
                            .listRowInsets(EdgeInsets())
                        NavigationLink(destination: DetailView(timer: timer)) {
                            EmptyView()
                        }.opacity(0)
                    }
                }
                .onDelete(perform: removeTimer)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Willpower")
            .navigationBarItems(trailing: Button("Add", action: addTimer))
        }
        .sheet(isPresented: $isCreatingTimer) {
            AddTimerView()
        }
    }
    
    private func addTimer() {
        isCreatingTimer = true
    }
    
    private func removeTimer(at offsets: IndexSet) {
        for index in offsets {
            let timer = timers[index]
            controller.delete(timer)
        }
        controller.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
