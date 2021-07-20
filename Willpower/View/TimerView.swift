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
    @ObservedObject var timer: WPTimer

    var body: some View {
        HStack {
            Text(timer.wrappedName)
            Spacer()
            if timer.isActive {
                PassedTimeView(timer: timer, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .frame(height: 64, alignment: .center)
        .background(timer.isActive ? Color.green : Color.gray)
    }
}

struct TimerView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        TimerView(timer: WPTimer.example(context: contextView))
    }
}
