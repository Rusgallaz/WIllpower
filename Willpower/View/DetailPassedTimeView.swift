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
    
    @State private var isCollapsed = true
    
    var body: some View {
        VStack {
            HStack {
                PassedTimeView(timer: timer, alignment: .leading)
                    .padding([.horizontal])
                Spacer()
                Image(systemName: isCollapsed ? "chevron.right" : "chevron.down")
                    .padding()

            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    self.isCollapsed.toggle()
                }
            }
            
            if !isCollapsed {
                DetailAdditionalInfoView(timer: timer)
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
