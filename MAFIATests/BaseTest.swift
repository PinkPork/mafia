//
//  BaseTest.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 1/9/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import XCTest
@testable import MAFIA

class BaseTest: XCTestCase {
    override func setUp() {
        super.setUp()
        CoreDataConnection.shared.managedContext = MockData.CoreDataController.managedObjectContext
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
