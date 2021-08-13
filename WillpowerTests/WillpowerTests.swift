//
//  WillpowerTests.swift
//  WillpowerTests
//
//  Created by Ruslan Gallyamov on 02.06.2021.
//


import CoreData
import XCTest
@testable import Willpower

class BaseTestCase: XCTestCase {
    var persistenceController: PersistenceController!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        managedObjectContext = persistenceController.container.viewContext
    }

}
