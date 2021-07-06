//
//  DetailPassedTimeView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 03.07.2021.
//

import SwiftUI
import CoreData

struct DetailPassedTimeView: View {
    let timer: WPTimer
    
    @State private var passedDate = ""
    @State private var passedTime = ""
    @State var timerEvent = Timer.publish(every: 1, tolerance: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if timer.passedMoreThanDay {
                    Text(passedDate)
                        .font(.title)
                    Text(passedTime)
                        .font(.headline)
                        .foregroundColor(.secondary)
                } else {
                    Text(passedTime)
                        .font(.title)
                }
            }
            .padding()
            Spacer()

        }
        .onAppear(perform: updatePassedTime)
        .onReceive(timerEvent) {_ in
            updatePassedTime()
        }
    }
    
    private func updatePassedTime() {
        if timer.isActive {
            passedDate = timer.passedDate
            passedTime = timer.passedTime
        }
    }
}

struct DetailPassedTimeView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        DetailPassedTimeView(timer: WPTimer.example(context: contextView))
    }
}
