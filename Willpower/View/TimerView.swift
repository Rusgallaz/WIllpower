//
//  TimerView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 03.06.2021.
//

import SwiftUI
import Combine
import CoreData

struct TimerView: View {
    @State private var timeValue: String
    @State private var timeType: String
    @State private var timerName: String
    @State var timerEvent = Timer.publish(every: 1.0, tolerance: 0.1, on: .main, in: .common).autoconnect()
    
    let timer: WPTimer
    
    init(timer: WPTimer) {
        self.timer = timer
        _timeValue = State(wrappedValue: String(timer.timeValue))
        _timeType = State(wrappedValue: timer.timeType)
        _timerName = State(wrappedValue: timer.wrappedName)
    }
    
    var body: some View {
        HStack {
            Text(timerName)
            Spacer()
            if timer.isActive {
                Text(timeValue)
                    .font(.largeTitle)
                Text(timeType)
                    .font(.headline)
            }
        }
        .padding(.horizontal)
        .frame(height: 64, alignment: .center)
        .background(timer.isActive ? Color.green : Color.gray)
        .onReceive(timerEvent) { _ in updateTimerValue() }
    }
    
    private func updateTimerValue() {
        timerName = timer.wrappedName
        if timer.isActive {
            timeValue = String(timer.timeValue)
            timeType = timer.timeType
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        TimerView(timer: WPTimer.example(context: contextView))
    }
}
