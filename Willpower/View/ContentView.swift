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
//    @State private var timers = [WPTimer]()
    let timers: FetchRequest<WPTimer>
    
    init() {
        timers = FetchRequest<WPTimer>(entity: WPTimer.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \WPTimer.isActive, ascending: false),
            NSSortDescriptor(keyPath: \WPTimer.startDate, ascending: true)
        ])
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(timers.wrappedValue) { timer in
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
            let timer = timers.wrappedValue[index]
            controller.delete(timer)
        }
        controller.save()
        fecthTimers()
    }
    
    private func fecthTimers() {
//        let fetchRequest = NSFetchRequest<WPTimer>(entityName: "WPTimer")
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(keyPath: \WPTimer.isActive, ascending: false),
//            NSSortDescriptor(keyPath: \WPTimer.startDate, ascending: true)
//        ]
//        guard let data = try? managedObjectContext.fetch(fetchRequest) else {
//            fatalError("Could load data from WPTimer ")
//        }
//
//        timers = data
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
