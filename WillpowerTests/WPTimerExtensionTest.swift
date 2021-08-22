//
//  WPTimerExtensionTest.swift
//  WillpowerTests
//
//  Created by Ruslan Gallyamov on 21.08.2021.
//

import XCTest
import CoreData
@testable import Willpower

class WPTimerExtensionTest: BaseTestCase {
    
    func testCreateTimerWithoutProperties() throws {
        let _ = createEmptyTimer()
        let timer = try getFirstTimer()
        XCTAssertEqual(timer.wrappedName, "Unknown")
        XCTAssertTrue(oneMinuteIntervalForNow().contains(timer.wrappedStarDate))
        XCTAssertEqual(timer.wrappedHistories.count, 0)
        XCTAssertFalse(timer.isActive)
    }
    
    func testCreateTimerWithProperties() throws {
        let name = "Timer name"
        let startDate = Date()
        let isActive = true
        let _ = createTimer(name: name, startDate: startDate, isActive: isActive)
        
        let timer = try getFirstTimer()
        XCTAssertEqual(timer.wrappedName, name)
        XCTAssertEqual(timer.startDate, startDate)
        XCTAssertEqual(timer.wrappedHistories.count, 0)
        XCTAssertTrue(timer.isActive)
    }
    
    func testTimerCheckPassedMoreThanDayWhenStartDateLessThanDayAgo() {
        let startDateComp = DateComponents(hour: -23, minute: -59)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertFalse(timer.passedMoreThanDay)
    }
    
    func testTimerCheckPassedMoreThanDayWhenStartDateMoreThanDayAgo() {
        let startDateComp = DateComponents(hour: -24, minute: -1)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertTrue(timer.passedMoreThanDay)
    }
    
    func testTimerCheckSecondsPassed() {
        let startDate = Date(timeIntervalSinceNow: -100)
        let timer = createTimer(startDate: startDate)
        
        XCTAssertTrue((100...102).contains(timer.secondsPassed))
    }
    
    func testTimerCheckPassedTimeWhenStartDate7SecondsAgo() {
        let startDateComp = DateComponents(second: -7)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedTime, "7")
    }
    
    func testTimerCheckPassedTimeWhenStartDate9Minutes10SecondsAgo() {
        let startDateComp = DateComponents(minute: -9, second: -10)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedTime, "9:10")
    }
    
    func testTimerCheckPassedTimeWhenStartDate23Hours59Minutes30SecondsAgo() {
        let startDateComp = DateComponents(hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedTime, "23:59:30")
    }
    
    func testTimerCheckPassedTimeWhenStartDateMoreThanDayAgo() {
        let startDateComp = DateComponents(month: -3, day: -10, hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedTime, "23:59:30")
    }
    
    func testTimerCheckPassedPrimaryDateWhenStartDateLessThanDayAgo() {
        let startDateComp = DateComponents(hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedPrimaryDate, "23:59:30")
    }
    
    func testTimerCheckPassedPrimaryDateWhenStartDate3DaysAgo() {
        let startDateComp = DateComponents(day: -3, hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedPrimaryDate, "3 days")
    }
    
    func testTimerCheckPassedPrimaryDateWhenStartDate11MonthsAgo() {
        let startDateComp = DateComponents(month: -11, day: -3, hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedPrimaryDate, "11 months")
    }
    
    func testTimerCheckPassedPrimaryDateWhenStartDate7YearsAgo() {
        let startDateComp = DateComponents(year: -7, month: -11, day: -3, hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedPrimaryDate, "7 years")
    }
    
    func testTimerCheckPassedSecondaryDateWhenStartDateLessThanDayAgo() {
        let startDateComp = DateComponents(hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedSecondaryDate, "23:59:30")
    }
    
    func testTimerCheckPassedSecondaryDateWhenStartDate3DaysAgo() {
        let startDateComp = DateComponents(day: -3, hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedSecondaryDate, "23:59:30")
    }
    
    func testTimerCheckPassedSecondaryDateWhenStartDate11MonthsAgo() {
        let startDateComp = DateComponents(month: -11, day: -3, hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedSecondaryDate, "3d 23:59:30")
    }
    
    func testTimerCheckPassedSecondaryDateWhenStartDate7YearsAgo() {
        let startDateComp = DateComponents(year: -7, month: -11, day: -3, hour: -23, minute: -59, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.passedSecondaryDate, "11mo 3d 23:59:30")
    }
    
    func testTimerCheckFormattedStartDate() {
        let startDateComp = DateComponents(year: 2021, month: 7, day: 21, hour: 23, minute: 3, second: 10)
        let startDate = Calendar.current.date(from: startDateComp)!
        let timer = createTimer(startDate: startDate)

        XCTAssertEqual(timer.formattedStartDate, "21.07.2021, 23:03")
    }
    
    func testTimerCheckFormattedTotalPassedTimeWithoutHistoryWithOneUnit() {
        let startDate = Date(timeIntervalSinceNow: -34)
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.formattedTotalPassedTime, "34 seconds")
    }
    
    func testTimerCheckFormattedTotalPassedTimeWithoutHistoryWithTwoUnits() {
        let startDateComp = DateComponents(minute: -9, second: -3)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.formattedTotalPassedTime, "9 minutes, 3 seconds")
    }
    
    func testTimerCheckFormattedTotalPassedTimeWithoutHistoryWithThreeUnits() {
        let startDateComp = DateComponents(month: -2, day: -13, hour: -4, minute: -9, second: -30)
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let timer = createTimer(startDate: startDate)
        
        XCTAssertEqual(timer.formattedTotalPassedTime, "2 months, 13 days, 4 hours")
    }
    
    func testTimerCheckFormattedTotalPassedTimeWithHistory() {
        let startDateComp = DateComponents(day: -1, hour: -1)
        let startDateHistoryComp = DateComponents(month: -2, day: -20, hour: -2)
        let endDateHistoryComp = DateComponents(month: -1, day: -18, hour: -1)
        
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let startDateHistory = Calendar.current.date(byAdding: startDateHistoryComp, to: Date())!
        let endDateHistory = Calendar.current.date(byAdding: endDateHistoryComp, to: Date())!

        let timer = createTimer(startDate: startDate)
        createHistory(for: timer, startDate: startDateHistory, endDate: endDateHistory)
        
        XCTAssertEqual(timer.formattedTotalPassedTime, "1 month, 2 days, 2 hours")
    }
    
    func testTimerCheckFormattedTotalPassedTimeWithHistoryForStoppedTimer() {
        let startDateComp = DateComponents(month: -1, day: -10, hour: -1)
        let startDateHistoryComp = DateComponents(month: -2, day: -20, hour: -2)
        let endDateHistoryComp = DateComponents(month: -1, day: -18, hour: -1)
        
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let startDateHistory = Calendar.current.date(byAdding: startDateHistoryComp, to: Date())!
        let endDateHistory = Calendar.current.date(byAdding: endDateHistoryComp, to: Date())!

        let timer = createTimer(startDate: startDate, isActive: false)
        createHistory(for: timer, startDate: startDateHistory, endDate: endDateHistory)
        
        XCTAssertEqual(timer.formattedTotalPassedTime, "1 month, 1 day, 1 hour")
    }
    
    func testTimerCheckHistoryOrders() {
        let startDateComp = DateComponents(day: -1, hour: -1)
        let startDateHistory1Comp = DateComponents(month: -2, day: -20, hour: -2)
        let endDateHistory1Comp = DateComponents(month: -1, day: -18, hour: -1)
        let startDateHistory2Comp = DateComponents(month: -1, day: -17, hour: -1)
        let endDateHistory2Comp = DateComponents(month: -1, day: -8, hour: -1)
        let startDateHistory3Comp = DateComponents(day: -15, hour: -1)
        let endDateHistory3Comp = DateComponents(day: -10, hour: -1)
        
        let startDate = Calendar.current.date(byAdding: startDateComp, to: Date())!
        let startDateHistory1 = Calendar.current.date(byAdding: startDateHistory1Comp, to: Date())!
        let endDateHistory1 = Calendar.current.date(byAdding: endDateHistory1Comp, to: Date())!
        let startDateHistory2 = Calendar.current.date(byAdding: startDateHistory2Comp, to: Date())!
        let endDateHistory2 = Calendar.current.date(byAdding: endDateHistory2Comp, to: Date())!
        let startDateHistory3 = Calendar.current.date(byAdding: startDateHistory3Comp, to: Date())!
        let endDateHistory3 = Calendar.current.date(byAdding: endDateHistory3Comp, to: Date())!

        let timer = createTimer(startDate: startDate)
        createHistory(for: timer, startDate: startDateHistory2, endDate: endDateHistory2)
        createHistory(for: timer, startDate: startDateHistory3, endDate: endDateHistory3)
        createHistory(for: timer, startDate: startDateHistory1, endDate: endDateHistory1)
        
        let histories = timer.wrappedHistories
        XCTAssertEqual(histories.count, 3)
        XCTAssertEqual(histories[0].startDate, startDateHistory3)
        XCTAssertEqual(histories[1].startDate, startDateHistory2)
        XCTAssertEqual(histories[2].startDate, startDateHistory1)
    }
    
    private func createEmptyTimer() -> WPTimer {
        return WPTimer(context: managedObjectContext)
    }
    
    private func createTimer(name: String = "Name", startDate: Date = Date(), isActive: Bool = true) -> WPTimer {
        let timer = WPTimer(context: managedObjectContext)
        timer.name = name
        timer.startDate = startDate
        timer.isActive = isActive
        return timer
    }
    
    private func createHistory(for timer: WPTimer, startDate: Date, endDate: Date) {
        let history = WPHistoryDates(context: managedObjectContext)
        history.startDate = startDate
        history.endDate = endDate
        history.timer = timer
    }
    
    private func getFirstTimer() throws -> WPTimer {
        let timers = try managedObjectContext.fetch(NSFetchRequest<WPTimer>(entityName: "WPTimer"))
        return timers[0]
    }
    
    private func oneMinuteIntervalForNow() -> ClosedRange<Date> {
        let now = Date()
        return now.addingTimeInterval(-30)...now.addingTimeInterval(30)
    }

}
