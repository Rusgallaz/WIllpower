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
            ZStack {
                Color(red: 233/255, green: 234/255, blue: 243/255).edgesIgnoringSafeArea(.all)
                ScrollView {
                    ForEach(timers) { timer in
                        NavigationLink(destination: DetailView(timer: timer)) {
                            TimerView(timer: timer)
                                .padding([.horizontal], 20)
                                .padding([.bottom], 10)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .onDelete(perform: removeTimer)
                }
                VStack {
                    Spacer()
                    Button(action: addTimer) {
                        Text("Add new timer")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background(Color(red: 107/255, green: 78/255, blue: 200/255))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .buttonStyle(.plain)
                    .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: 2)
                    .padding([.horizontal], 30)
                    .padding([.bottom], 20)
                }
                
            }
            .navigationBarTitle("Timers")
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
