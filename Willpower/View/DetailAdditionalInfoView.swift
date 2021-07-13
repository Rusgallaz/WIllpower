//
//  DetailAdditionalInfoView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 13.07.2021.
//

import SwiftUI
import CoreData

struct DetailAdditionalInfoView: View {
    
    let timer: WPTimer
    
    var body: some View {
        VStack {
            HStack {
                Text("Started date:")
                Spacer()
                Text(timer.formattedStartDate)
            }
            HStack {
                Text("Total time:")
                Spacer()
                Text(timer.formattedTotalPassedTime)
            }
        }
        .padding([.horizontal])
    }
}

struct DetailAdditionalInfoView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        DetailAdditionalInfoView(timer: WPTimer.example(context: contextView))
    }
}
