//
//  WPHistoryDates.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 15.06.2021.
//

import Foundation
import CoreData

extension WPHistoryDates {

    var wrappedStartDate: Date {
        return startDate ?? Date()
    }

    var wrappedEndDate: Date {
        return endDate ?? Date()
    }

    var formattedStartDate: String {
        return formatDate(date: wrappedStartDate)
    }

    var formattedEndDate: String {
        return formatDate(date: wrappedEndDate)

    }

    var passedTimeFormatted: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 2

        return formatter.string(from: wrappedStartDate, to: wrappedEndDate) ?? "Unknown"
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: date)
    }

    static func example(context: NSManagedObjectContext) -> WPHistoryDates {
        let dates = WPHistoryDates(context: context)
        let startDateComp1 = DateComponents(month: -1, day: -6, hour: -19)
        let endDateComp1 = DateComponents(month: -1, day: -1, hour: -9)
        dates.startDate = Calendar.current.date(byAdding: startDateComp1, to: Date())
        dates.endDate = Calendar.current.date(byAdding: endDateComp1, to: Date())
        return dates
    }
}
