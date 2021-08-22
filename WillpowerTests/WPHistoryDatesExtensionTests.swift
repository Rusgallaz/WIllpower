//
//  WPHistoryDatesTests.swift
//  WillpowerTests
//
//  Created by Ruslan Gallyamov on 22.08.2021.
//

import XCTest
import CoreData
@testable import Willpower

class WPHistoryDatesExtensionTests: BaseTestCase {
    
    func testCreateHistoryWithoutProperties() throws {
        createEmptyHistory()
        
        let history = try getFirstHistory()
        XCTAssertTrue(oneMinuteIntervalForNow().contains(history.wrappedStartDate))
        XCTAssertTrue(oneMinuteIntervalForNow().contains(history.wrappedEndDate))
        XCTAssertNil(history.timer)
    }
    
    func testCreateHistoryWithProperties() throws {
        let startDate = Date(timeIntervalSinceNow: -100)
        let endDate = Date(timeIntervalSinceNow: -10)
        let _ = createHistory(startDate: startDate, endDate: endDate)
        
        let history = try getFirstHistory()
        XCTAssertEqual(history.wrappedStartDate, startDate)
        XCTAssertEqual(history.wrappedEndDate, endDate)
    }
    
    func testHistoryCheckFormattedStartEndDate() {
        let startDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 2, minute: 20, second: 10)
        let endDateHistoryComp = DateComponents(year: 2021, month: 7, day: 22, hour: 2, minute: 20, second: 10)
        let startDateHistory = Calendar.current.date(from: startDateHistoryComp)!
        let endDateHistory = Calendar.current.date(from: endDateHistoryComp)!

        let history = createHistory(startDate: startDateHistory, endDate: endDateHistory)
        XCTAssertEqual(history.formattedStartDate, "22.07.2020, 02:20")
        XCTAssertEqual(history.formattedEndDate, "22.07.2021, 02:20")
    }
    
    func testHistoryCheckPassedTimeFormatted50Seconds() {
        let startDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 0, minute: 0, second: 0)
        let endDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 0, minute: 0, second: 50)
        let startDateHistory = Calendar.current.date(from: startDateHistoryComp)!
        let endDateHistory = Calendar.current.date(from: endDateHistoryComp)!

        let history = createHistory(startDate: startDateHistory, endDate: endDateHistory)
        XCTAssertEqual(history.passedTimeFormatted, "50 seconds")
    }
    
    func testHistoryCheckPassedTimeFormatted59Minutes50Seconds() {
        let startDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 0, minute: 0, second: 0)
        let endDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 0, minute: 59, second: 50)
        let startDateHistory = Calendar.current.date(from: startDateHistoryComp)!
        let endDateHistory = Calendar.current.date(from: endDateHistoryComp)!

        let history = createHistory(startDate: startDateHistory, endDate: endDateHistory)
        XCTAssertEqual(history.passedTimeFormatted, "59 minutes, 50 seconds")
    }
    
    func testHistoryCheckPassedTimeFormatted22Hours30Minutes() {
        let startDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 1, minute: 0, second: 0)
        let endDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 23, minute: 30, second: 10)
        let startDateHistory = Calendar.current.date(from: startDateHistoryComp)!
        let endDateHistory = Calendar.current.date(from: endDateHistoryComp)!

        let history = createHistory(startDate: startDateHistory, endDate: endDateHistory)
        XCTAssertEqual(history.passedTimeFormatted, "22 hours, 30 minutes")
    }
    
    func testHistoryCheckPassedTimeFormatted4Days23Hours() {
        let startDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 0, minute: 0, second: 0)
        let endDateHistoryComp = DateComponents(year: 2020, month: 7, day: 26, hour: 23, minute: 1, second: 0)
        let startDateHistory = Calendar.current.date(from: startDateHistoryComp)!
        let endDateHistory = Calendar.current.date(from: endDateHistoryComp)!

        let history = createHistory(startDate: startDateHistory, endDate: endDateHistory)
        XCTAssertEqual(history.passedTimeFormatted, "4 days, 23 hours")
    }
    
    func testHistoryCheckPassedTimeFormatted11Months5Days() {
        let startDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 0, minute: 0, second: 0)
        let endDateHistoryComp = DateComponents(year: 2021, month: 6, day: 26, hour: 23, minute: 59, second: 50)
        let startDateHistory = Calendar.current.date(from: startDateHistoryComp)!
        let endDateHistory = Calendar.current.date(from: endDateHistoryComp)!

        let history = createHistory(startDate: startDateHistory, endDate: endDateHistory)
        XCTAssertEqual(history.passedTimeFormatted, "11 months, 5 days")
    }
    
    func testHistoryCheckPassedTimeFormatted8Years11Months() {
        let startDateHistoryComp = DateComponents(year: 2020, month: 7, day: 22, hour: 0, minute: 0, second: 0)
        let endDateHistoryComp = DateComponents(year: 2029, month: 6, day: 26, hour: 23, minute: 59, second: 50)
        let startDateHistory = Calendar.current.date(from: startDateHistoryComp)!
        let endDateHistory = Calendar.current.date(from: endDateHistoryComp)!

        let history = createHistory(startDate: startDateHistory, endDate: endDateHistory)
        XCTAssertEqual(history.passedTimeFormatted, "8 years, 11 months")
    }
    
    @discardableResult
    private func createEmptyHistory() -> WPHistoryDates {
        return WPHistoryDates(context: managedObjectContext)
    }
    
    private func createHistory(startDate: Date, endDate: Date) -> WPHistoryDates{
        let history = WPHistoryDates(context: managedObjectContext)
        history.startDate = startDate
        history.endDate = endDate
        return history
    }
    
    private func getFirstHistory() throws -> WPHistoryDates {
        let history = try managedObjectContext.fetch(NSFetchRequest<WPHistoryDates>(entityName: "WPHistoryDates"))
        return history[0]
    }
    
    private func oneMinuteIntervalForNow() -> ClosedRange<Date> {
        let now = Date()
        return now.addingTimeInterval(-30)...now.addingTimeInterval(30)
    }

}

