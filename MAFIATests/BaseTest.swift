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
        super.tearDown()
    }        
}
