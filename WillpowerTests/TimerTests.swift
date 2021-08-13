//
//  TimerTests.swift
//  WillpowerTests
//
//  Created by Ruslan Gallyamov on 14.08.2021.
//

import XCTest
import CoreData
@testable import Willpower

class TimerTests: BaseTestCase {
    
    func testCreatingTimersWithoutHistory() {
        let targetCount = 3
        
        (0..<targetCount).forEach { _ in
            let _ = WPTimer(context: managedObjectContext)
        }
        
        XCTAssertEqual(persistenceController.count(for: WPTimer.fetchRequest()), targetCount)
    }
}
