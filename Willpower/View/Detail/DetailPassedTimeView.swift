//
//  DetailPassedTimeView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 03.07.2021.
//

import SwiftUI
import CoreData

struct DetailPassedTimeView: View {
    @ObservedObject var timer: WPTimer

    @State private var isShowingAdditional = false

    var body: some View {
        VStack {
            HStack {
                if timer.isActive {
                    PassedTimeView(timer: timer, alignment: .leading)
                } else {
                    StoppedTimerView()
                }
                Spacer()
                Image(systemName: isShowingAdditional ? "chevron.down" : "chevron.right")
                    .foregroundColor(.WPActionColor)
            }
            .padding(.horizontal)
            .contentShape(Rectangle())
            .onTapGesture(perform: toggleAdditionalInfo)

            if isShowingAdditional {
                DetailAdditionalInfoView(timer: timer)
                    .padding([.top], 5)
            }
        }
    }

    private func toggleAdditionalInfo() {
        withAnimation {
            self.isShowingAdditional.toggle()
        }
    }
}

struct DetailPassedTimeView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        DetailPassedTimeView(timer: WPTimer.example(context: contextView))
    }
}
