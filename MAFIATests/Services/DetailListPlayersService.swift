//
//  DetailListPlayersService.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 1/5/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation


import XCTest
@testable import MAFIA

class DetailListPlayersServiceTest: BaseTest {
    
    var service: DetailListPlayersService!
    var list: PlayersListMO!
    
    override func setUp() {
        super.setUp()
        service = DetailListPlayersService()
        list = PlayersListMO(entity: CoreDataConnection.shared.getEntity(withName: PlayersListMO.entityName)!, insertInto: CoreDataConnection.shared.managedContext)
        list.name = MockData.PlayersList.name
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddPlayersToList() {
        service.add(toList: list, playerWithName: MockData.Player.name) { (playersAdded) in
            XCTAssertNotNil(playersAdded, "There was an error adding the players")
            print("-----------------------------------------------------------")
            print("\n The player named: \(playersAdded!.name) was added to the list named: \(list.name) \n")
            print("-----------------------------------------------------------")
        }
    }
    
    func testRemovePlayerFromList() {
        
        service.add(toList: list, playerWithName: MockData.Player.name1) { (playersAdded) in
            XCTAssertNotNil(playersAdded, "There was an error adding the players")
            XCTAssertNotNil(list.players, "There was an error with the players in the current list")
            if let firstPlayer: PlayerMO = list.players?.toArray().first {
                print("\n ------ Removing player named: \(firstPlayer.name) from list: \(list.name) ------")
                service.remove(firstPlayer, fromList: list, completion: { (success) in
                    if success {
                        print("\n ------ The player was removed from list ------")
                        if let newFirstPlayer: PlayerMO = list.players?.toArray().first {
                            print("\n ------ Now the first player is named: \(newFirstPlayer.name) ------ \n")
                        }
                    }
                })
            }
        }
    }
}
