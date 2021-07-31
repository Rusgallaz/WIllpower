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

    var secondsPassed: TimeInterval {
        abs(wrappedStarDate.timeIntervalSinceNow)
    }

    var wrappedName: String {
        name ?? "Unkown"
    }

    var wrappedStarDate: Date {
        return startDate ?? Date()
    }

    var wrappedHistories: [WPHistoryDates] {
        let setDate = historyDates as? Set<WPHistoryDates> ?? Set<WPHistoryDates>()
        return Array(setDate).sorted { $0.wrappedStartDate > $1.wrappedStartDate}
    }

    var passedMoreThanDay: Bool {
        return secondsPassed > WPTimer.oneDayInSeconds
    }

    private func passedDateComponent(
        dateComponents: DateComponents,
        style: DateComponentsFormatter.UnitsStyle
    ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = style

        return formatter.string(from: dateComponents) ?? "Unknown"
    }

    var passedTime: String {
        var diffComponents = Calendar.current.dateComponents(
            [.day, .hour, .minute, .second],
            from: wrappedStarDate,
            to: Date()
        )
        diffComponents.day = 0

        return passedDateComponent(dateComponents: diffComponents, style: .positional)
    }

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

    var totalPassedSeconds: TimeInterval {
        var timePassed = wrappedHistories.map { $0.wrappedEndDate.timeIntervalSince($0.wrappedStartDate) }.reduce(0, +)
        if isActive {
            timePassed += secondsPassed
        }
        return timePassed
    }

    var formattedTotalPassedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 3

        return formatter.string(from: totalPassedSeconds) ?? "Unknown"
    }

    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: wrappedStarDate)
    }

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
        let endDateComp2 = DateComponents( day: -15, hour: -1)
        dates2.startDate = Calendar.current.date(byAdding: startDateComp2, to: Date())
        dates2.endDate = Calendar.current.date(byAdding: endDateComp2, to: Date())

        let dates3 = WPHistoryDates(context: context)
        let startDateComp3 = DateComponents(day: -5, hour: -9)
        let endDateComp3 = DateComponents( day: -1, hour: -20)
        dates3.startDate = Calendar.current.date(byAdding: startDateComp3, to: Date())
        dates3.endDate = Calendar.current.date(byAdding: endDateComp3, to: Date())

        timer.historyDates = NSSet(objects: dates1, dates2, dates3)

        return timer
    }
}
