//
//  ListHistoryView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 03.07.2021.
//

import SwiftUI
import CoreData

struct ListHistoryView: View {
    
    let history: [WPHistoryDates]
    
    var body: some View {
        List(history, id:\.self) { history in
            HistoryRowView(historyDates: history)
                .listRowInsets(EdgeInsets())
        }
        .listStyle(InsetListStyle())
    }
}

struct ListHistoryView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        ListHistoryView(history: WPTimer.example(context: contextView).wrappedHistories)
    }
}
