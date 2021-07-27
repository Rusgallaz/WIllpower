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
        VStack(alignment: .leading) {
            Text("Start date:")
                .foregroundColor(.secondary)
            Text(timer.formattedStartDate)
                .bold()
                .padding([.bottom], 3)
            Text("Total time:")
                .foregroundColor(.secondary)
            Text(timer.formattedTotalPassedTime)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal])
    }
}

struct DetailAdditionalInfoView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        DetailAdditionalInfoView(timer: WPTimer.example(context: contextView))
    }
}
