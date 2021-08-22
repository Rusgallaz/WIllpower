//
//  WillpowerUITests.swift
//  WillpowerUITests
//
//  Created by Ruslan Gallyamov on 02.06.2021.
//

import XCTest

class WillpowerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
}
