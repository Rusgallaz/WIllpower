//
//  PassedTimeView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 19.07.2021.
//

import SwiftUI
import CoreData

struct PassedTimeView: View {
    let timer: WPTimer
    
    @State private var passedPrimaryTime = ""
    @State private var passedSecondaryTime = ""
    
    @State var timerEvent = Timer.publish(every: 1, tolerance: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            if timer.passedMoreThanDay {
                Text(passedPrimaryTime)
                    .font(.title)
                Text(passedSecondaryTime)
                    .font(.headline)
                    .foregroundColor(.secondary)
            } else {
                Text(passedPrimaryTime)
                    .font(.title)
            }
        }
        .onAppear(perform: updatePassedTime)
        .onReceive(timerEvent) {_ in
            updatePassedTime()
        }
    }
    
    private func updatePassedTime() {
        if timer.isActive {
            passedPrimaryTime = timer.passedPrimaryTime
            passedSecondaryTime = timer.passedTime
        }
    }
}

struct PassedTimeView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        PassedTimeView(timer: WPTimer.example(context: contextView))
    }
}
