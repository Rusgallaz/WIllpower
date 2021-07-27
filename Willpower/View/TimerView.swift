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
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(timer.isActive ? .primary : .secondary)
            Spacer()
            if timer.isActive {
                PassedTimeView(timer: timer, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .frame(height: 70, alignment: .center)
        .background(timer.isActive ? Color.white : Color.WPDeactivate)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}

struct TimerView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        TimerView(timer: WPTimer.example(context: contextView))
    }
}
