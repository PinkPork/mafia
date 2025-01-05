//
//  BasePresenterTest.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 4/4/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import XCTest

class BasePresenterTest: XCTestCase {

    var players: [Player]!
    var lists: [PlayerList]!
    
    override func setUp() {
        super.setUp()
        players = getMockPlayers()
        lists = getMockLists()
    }
    
    override func tearDown() {        
        super.tearDown()
    }

    /// Gets 5 mock players with different name and the same role **Role.none** for test
    /// - returns: An Array `Player` with mockData
    func getMockPlayers() -> [Player] {
        return MockData.Player.Players.map({ (name) -> Player in
            return Player(name: name)
        })
    }

    /// Gets 5 mock list with different name
    /// - returns: An Array `PlayerList` with mockData
    func getMockLists() -> [PlayerList] {
        return MockData.PlayersList.rawLists.map({ (name) -> PlayerList in
            return PlayerList(name: name)
        })
    }
    
}
