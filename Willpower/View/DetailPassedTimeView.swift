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
                        .padding([.horizontal])
                } else {
                    Text("Timer is stopped")
                        .font(.title)
                        .padding([.horizontal])
                        .padding([.bottom], 0)
                }
                Spacer()
                Image(systemName: isShowingAdditional ? "chevron.down" : "chevron.right")
                    .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    self.isShowingAdditional.toggle()
                }
            }
            
            if isShowingAdditional {
                DetailAdditionalInfoView(timer: timer)
                    .padding([.top], 5)
            }
        }
    }
}

struct DetailPassedTimeView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        DetailPassedTimeView(timer: WPTimer.example(context: contextView))
    }
}
