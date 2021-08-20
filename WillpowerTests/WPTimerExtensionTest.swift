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
        createTimer()
        let timer = try getFirstTimer()
        XCTAssertEqual(timer.wrappedName, "Unknown")
        XCTAssertTrue(oneMinuteInterval().contains(timer.wrappedStarDate))
        XCTAssertEqual(timer.wrappedHistories.count, 0)
        XCTAssertFalse(timer.isActive)
    }
    
    func testCreateTimerWithProperties() throws {
        let name = "Timer name"
        let startDate = Date()
        let isActive = true
        createTimer(name: name, startDate: startDate, isActive: isActive)
        let timer = try getFirstTimer()
        XCTAssertEqual(timer.wrappedName, name)
        XCTAssertEqual(timer.startDate, startDate)
        XCTAssertEqual(timer.wrappedHistories.count, 0)
        XCTAssertTrue(timer.isActive)
    }
    
    private func createTimer() {
        let _ = WPTimer(context: managedObjectContext)
    }
    
    private func createTimer(name: String, startDate: Date, isActive: Bool) {
        let timer = WPTimer(context: managedObjectContext)
        timer.name = name
        timer.startDate = startDate
        timer.isActive = isActive
    }
    
    private func getFirstTimer() throws -> WPTimer {
        let timers = try managedObjectContext.fetch(NSFetchRequest<WPTimer>(entityName: "WPTimer"))
        return timers[0]
    }
    
    private func oneMinuteInterval() -> ClosedRange<Date> {
        let now = Date()
        return now.addingTimeInterval(-30)...now.addingTimeInterval(30)
    }

}
