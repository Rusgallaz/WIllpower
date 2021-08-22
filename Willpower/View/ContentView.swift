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
    @State private var isShowingMenu = false
    @State private var isCreatingTimer = false

    private var addTimerButton: some View {
        Button(action: {
            isCreatingTimer = true
        }, label: {
            Image(systemName: "plus")
                .font(.title)
        })
        .accessibilityIdentifier("addTimerButton")
    }

    private var showMenuButton: some View {
        Button(action: {
            withAnimation {
                self.isShowingMenu.toggle()
            }
        }, label: {
            Image(systemName: "line.horizontal.3")
                .font(.title)
        })
    }

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Color.WPBackground.edgesIgnoringSafeArea(.all)
                    TimersListView()
                }
                .navigationBarTitle("Timers", displayMode: .inline)
                .navigationBarItems(leading: showMenuButton, trailing: addTimerButton)
                .sheet(isPresented: $isCreatingTimer) {
                    AddTimerView()
                }
            }
            .accentColor(Color.WPActionColor)

            MenuView(isOpen: self.$isShowingMenu)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
