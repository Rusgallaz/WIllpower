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
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(timer.isActive ? .black : .white)
            Spacer()
            if timer.isActive {
                PassedTimeView(timer: timer, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .frame(height: 86, alignment: .center)
        .background(timer.isActive ? Color.white : Color(red: 84/255, green: 83/255, blue: 88/255))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}

struct TimerView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        TimerView(timer: WPTimer.example(context: contextView))
    }
}
