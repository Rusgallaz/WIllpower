//
//  WPTimer.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 04.06.2021.
//

import Foundation
import CoreData

extension WPTimer {

    private static let oneDayInSeconds: Double = 60*60*24
    
    /// Name of the timer or "Unknown" (if name is nil)
    var wrappedName: String {
        name ?? "Unknown"
    }

    /// Last start date of the timer or current date (if startDate is nil)
    var wrappedStarDate: Date {
        return startDate ?? Date()
    }
    
    
    /// Timer histories sorted by start date in descending order.
    var wrappedHistories: [WPHistoryDates] {
        let setDate = historyDates as? Set<WPHistoryDates> ?? Set<WPHistoryDates>()
        return Array(setDate).sorted { $0.wrappedStartDate > $1.wrappedStartDate}
    }

    /// How many seconds have passed since the last start of the timer
    var secondsPassed: TimeInterval {
        abs(wrappedStarDate.timeIntervalSinceNow)
    }

    ///  Return true if the timer was started more than one day ago.
    var passedMoreThanDay: Bool {
        return secondsPassed > WPTimer.oneDayInSeconds
    }

    
    /// Calculates time between start date and now, and returns hours, minutes and seconds. Style - positional.
    ///
    /// Example: A timer started 4 months 12 days 2 hours 56 minutes and 38 seconds ago. The function returns 2:56:38.
    var passedTime: String {
        var diffComponents = Calendar.current.dateComponents(
            [.day, .hour, .minute, .second],
            from: wrappedStarDate,
            to: Date()
        )
        diffComponents.day = 0

        return passedDateComponent(dateComponents: diffComponents, style: .positional)
    }

    /// Calculates time between start date and now, and  returns value of the first date component. Style - full.
    ///
    /// Example: A timer started 4 months 12 days 2 hours 56 minutes and 38 seconds ago. The function returns 4 months.
    var passedPrimaryDate: String {
        let allComponents = Calendar.current.dateComponents([.year, .month, .day], from: wrappedStarDate, to: Date())
        var diffComponents = DateComponents()
        if let years = allComponents.year, years > 0 {
            diffComponents.year = years
        } else if let months = allComponents.month, months > 0 {
            diffComponents.month = months
        } else if let days = allComponents.day, days > 0 {
            diffComponents.day = days
        } else {
            return passedTime
        }

        return passedDateComponent(dateComponents: diffComponents, style: .full)
    }

    /// Calculates time between start date and now, and  returns values of all date components except the first. Style - abbreviated and positional.
    ///
    /// Example: A timer started 4 months 12 days 2 hours 56 minutes and 38 seconds ago. The function returns 12d 2:56:38.
    var passedSecondaryDate: String {
        var diffComponents = Calendar.current.dateComponents([.year, .month, .day], from: wrappedStarDate, to: Date())
        if let years = diffComponents.year, years > 0 {
            diffComponents.year = 0
        } else if let months = diffComponents.month, months > 0 {
            diffComponents.month = 0
        } else {
            return passedTime
        }

        let passed = passedDateComponent(dateComponents: diffComponents, style: .abbreviated)
        return "\(passed) \(passedTime)"
    }

    /// Total passed time for the timer including history. Shows only the first 3 units.
    var formattedTotalPassedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 3

        return formatter.string(from: totalPassedSeconds) ?? "Unknown"
    }

    /// The date  the timer  started. Format - "dd.MM.yyyy, HH:mm".
    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: wrappedStarDate)
    }
    
    /// The sum of all time intervals between end - start dates of each history of the timer, plus passed seconds since last start date if the timer is active.
    private var totalPassedSeconds: TimeInterval {
        var timePassed = wrappedHistories.map { $0.wrappedEndDate.timeIntervalSince($0.wrappedStartDate) }.reduce(0, +)
        if isActive {
            timePassed += secondsPassed
        }
        return timePassed
    }
    
    
    /// Returns a formatted string based on the specified date component and unit style.
    /// - Returns: A formatted string representing the specified date information or "Unknown".
    private func passedDateComponent(
        dateComponents: DateComponents,
        style: DateComponentsFormatter.UnitsStyle
    ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = style

        return formatter.string(from: dateComponents) ?? "Unknown"
    }
}


// For preview and testing purposes.
extension WPTimer {
    static func example(context: NSManagedObjectContext) -> WPTimer {
        let timer = WPTimer(context: context)
        timer.name = "Example"
//        let startDateComp = DateComponents(month: -2 , day: -10, hour: -2, minute: -32, second: -14)
        let startDateComp = DateComponents(hour: -2, minute: -32, second: -14)
        timer.startDate = Calendar.current.date(byAdding: startDateComp, to: Date())
        timer.isActive = true

        let dates1 = WPHistoryDates(context: context)
        let startDateComp1 = DateComponents(month: -1, day: -6, hour: -19)
        let endDateComp1 = DateComponents(month: -1, day: -1, hour: -9)
        dates1.startDate = Calendar.current.date(byAdding: startDateComp1, to: Date())
        dates1.endDate = Calendar.current.date(byAdding: endDateComp1, to: Date())

        let dates2 = WPHistoryDates(context: context)
        let startDateComp2 = DateComponents(day: -25, hour: -13)
        let endDateComp2 = DateComponents(day: -15, hour: -1)
        dates2.startDate = Calendar.current.date(byAdding: startDateComp2, to: Date())
        dates2.endDate = Calendar.current.date(byAdding: endDateComp2, to: Date())

        let dates3 = WPHistoryDates(context: context)
        let startDateComp3 = DateComponents(day: -5, hour: -9)
        let endDateComp3 = DateComponents(day: -1, hour: -20)
        dates3.startDate = Calendar.current.date(byAdding: startDateComp3, to: Date())
        dates3.endDate = Calendar.current.date(byAdding: endDateComp3, to: Date())

        timer.historyDates = NSSet(objects: dates1, dates2, dates3)

        return timer
    }
}
