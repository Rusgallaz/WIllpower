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
    let alignment: HorizontalAlignment
    
    @State private var passedPrimaryDate = ""
    @State private var passedSecondaryDate = ""
    
    @State var timerEvent = Timer.publish(every: 1, tolerance: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(passedPrimaryDate)
                .font(timer.passedMoreThanDay ? .title2 : .title)
                .fontWeight(.semibold)
            
            if timer.passedMoreThanDay {
                Text(passedSecondaryDate)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear(perform: updatePassedTime)
        .onReceive(timerEvent) {_ in
            updatePassedTime()
        }
    }
    
    private func updatePassedTime() {
        if timer.isActive {
            passedPrimaryDate = timer.passedPrimaryDate
            passedSecondaryDate = timer.passedSecondaryDate
        }
    }
}

struct PassedTimeView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        PassedTimeView(timer: WPTimer.example(context: contextView), alignment: .leading)
    }
}
