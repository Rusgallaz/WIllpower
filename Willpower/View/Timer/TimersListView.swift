//
//  TimerListView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 31.07.2021.
//

import SwiftUI

struct TimersListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: WPTimer.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \WPTimer.isActive, ascending: false),
            NSSortDescriptor(keyPath: \WPTimer.startDate, ascending: true)
        ]
    )
    var timers: FetchedResults<WPTimer>

    var body: some View {
        ScrollView {
            VStack {
                ForEach(timers) { timer in
                    NavigationLink(destination: DetailView(timer: timer)) {
                        TimerView(timer: timer)
                            .padding([.horizontal], 20)
                            .padding([.bottom], 1)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top)
        }
    }
}

struct TimerListView_Previews: PreviewProvider {
    static var previews: some View {
        TimersListView()
            .padding([.top], 40)
            .background(Color.WPBackground).edgesIgnoringSafeArea(.all)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
