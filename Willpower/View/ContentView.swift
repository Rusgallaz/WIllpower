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
    @State private var timers = [WPTimer]()
    
    
//    @FetchRequest(
//        entity: WPTimer.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \WPTimer.isActive, ascending: false),
//                          NSSortDescriptor(keyPath: \WPTimer.startDate, ascending: true)]
//    )
//    var timers: FetchedResults<WPTimer>

    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< timers.count, id: \.self) { index in
                    ZStack {
                        TimerView(timer: timers[index])
                            .listRowInsets(EdgeInsets())
                        NavigationLink(destination: DetailView(timer: timers[index])) {
                            EmptyView()
                        }.opacity(0)
                    }
                }
                .onDelete(perform: removeTimer)
            }
            .onAppear(perform: fecthTimers)
            .listStyle(PlainListStyle())
            .navigationBarTitle("Willpower")
            .navigationBarItems(trailing: Button("Add", action: addTimer))
        }
        .sheet(isPresented: $isCreatingTimer, onDismiss: fecthTimers) {
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
        fecthTimers()
    }
    
    private func fecthTimers() {
        let fetchRequest = NSFetchRequest<WPTimer>(entityName: "WPTimer")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \WPTimer.isActive, ascending: false),
            NSSortDescriptor(keyPath: \WPTimer.startDate, ascending: true)
        ]
        guard let data = try? managedObjectContext.fetch(fetchRequest) else {
            fatalError("Could load data from WPTimer ")
        }

        timers = data
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
