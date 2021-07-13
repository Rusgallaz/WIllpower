//
//  WPTimer.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 04.06.2021.
//

import Foundation
import CoreData

extension WPTimer {
    
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
    
    var timeValue: Int {
        switch secondsPassed {
        case 0...60:
            return Int(secondsPassed)
        case 60...(60*60):
            return Int(secondsPassed / 60)
        case (60*60)...(60*60*24):
            return Int(secondsPassed / (60*60))
        case (60*60*24)...:
            return Int(secondsPassed / (60*60*24))
        default:
            return 0
        }
    }
    
    var timeType: String {
        switch secondsPassed {
        case 0...60:
            return "Seconds"
        case 60...(60*60):
            return "Minutes"
        case (60*60)...(60*60*24):
            return "Hours"
        case (60*60*24)...:
            return "Days"
        default:
            return "Unknown"
        }
    }
    
    var passedMoreThanDay: Bool {
        return secondsPassed > 60*60*24
    }
    
    var passedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        
        return formatter.string(from: secondsPassed.truncatingRemainder(dividingBy: 60*60*24)) ?? "Unknown"
    }
    
    var passedDate: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.month, .day,]
        
        return formatter.string(from: wrappedStarDate, to: Date()) ?? "Unknown"
    }
    var totalPassedTime: TimeInterval {
        let historiesTimePassed = wrappedHistories.map { $0.wrappedEndDate.timeIntervalSince($0.wrappedStartDate) }.reduce(0, +)
        return secondsPassed + historiesTimePassed
    }
    
    var formattedTotalPassedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.month, .day, .hour]
        
        return formatter.string(from: totalPassedTime) ?? "Unknown"
    }
    
    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: wrappedStarDate)
    }
    
    static var exampleTimer: WPTimer {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        let timer = WPTimer(context: context)
        timer.name = "Example"
        let startDateComp = DateComponents(day: -1, hour: -2, minute: -32, second: -14)
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
    
    static func example(context: NSManagedObjectContext) -> WPTimer {
        let timer = WPTimer(context: context)
        timer.name = "Example"
        let startDateComp = DateComponents(day: -1, hour: -2, minute: -32, second: -14)
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
