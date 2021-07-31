//
//  HistoryRowView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 03.07.2021.
//

import SwiftUI
import CoreData

struct HistoryRowView: View {
    
    let historyDates: WPHistoryDates
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(historyDates.passedTimeFormatted)
                .font(.headline)
            
            Text("\(historyDates.formattedStartDate) - \(historyDates.formattedEndDate)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct HistoryRowView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        HistoryRowView(historyDates: WPHistoryDates.example(context: contextView))
    }
}
