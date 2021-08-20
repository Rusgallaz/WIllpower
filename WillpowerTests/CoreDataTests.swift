//
//  TimerTests.swift
//  WillpowerTests
//
//  Created by Ruslan Gallyamov on 14.08.2021.
//

import XCTest
import CoreData
@testable import Willpower

class CoreDataTests: BaseTestCase {
    
    func testCreatingTimersWithoutHistory() {
        let timersCount = 3
        
        generateTimersWithDates(timersCount: timersCount, historiesPerTimerCount: 0)

        XCTAssertEqual(persistenceController.count(for: WPTimer.fetchRequest()), 3)
    }
    
    func testCreatingTimersWithHistory() {
        let timersCount = 3
        let historiesPerTimerCount = 4
        
        generateTimersWithDates(timersCount: timersCount, historiesPerTimerCount: historiesPerTimerCount)
        
        XCTAssertEqual(persistenceController.count(for: WPTimer.fetchRequest()), 3)
        XCTAssertEqual(persistenceController.count(for: WPHistoryDates.fetchRequest()), 12)
    }
    
    func testDeletingTimerCascadeDeleteHistories() throws {
        let timersCount = 3
        let historiesPerTimerCount = 4
        
        generateTimersWithDates(timersCount: timersCount, historiesPerTimerCount: historiesPerTimerCount)
        
        let timers = try managedObjectContext.fetch(NSFetchRequest<WPTimer>(entityName: "WPTimer"))
        persistenceController.delete(timers[0])
        
        XCTAssertEqual(persistenceController.count(for: WPTimer.fetchRequest()), 2)
        XCTAssertEqual(persistenceController.count(for: WPHistoryDates.fetchRequest()), 8)
    }
    
    private func generateTimersWithDates(timersCount: Int, historiesPerTimerCount: Int) {
        for _ in 0..<timersCount {
            let timer = WPTimer(context: managedObjectContext)
            
            for _ in 0..<historiesPerTimerCount {
                let historyDates = WPHistoryDates(context: managedObjectContext)
                historyDates.timer = timer
            }
        }
    }
}
