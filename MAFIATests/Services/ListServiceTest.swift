//
//  PlayersListServiceTest.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import XCTest
@testable import MAFIA

class ListServiceTest: BaseTest {
    
    var service: ListService!
    
    override func setUp() {
        super.setUp()
        service = ListService()        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreatePlayList() {
        service.createListWith(name: MockData.PlayersList.name, completion: { (playerList) in
            XCTAssertNotNil(playerList, "There was a problem creating a list with name: \(MockData.PlayersList.name)")
        })
    }
    
    func testGetAllLists() {
        for list in MockData.PlayersList.rawLists {
            service.createListWith(name: list, completion: { (playerList) in
                XCTAssertNotNil(playerList, "There was a problem creating a list with name: \(MockData.PlayersList.name)")
            })
        }

        service.getLists { (players) in
            XCTAssertNotNil(players, "The players list is empty")
            if let allLists = players {
                print("\n \n ------------------------------------------------------------------------ \n \n")
                for list in allLists {
                    print("\n El nombre de la lista es: " + list.name + "\n")
                    for player in list.players {
                        print(" * Jugador: " + player.name)
                    }
                }
                print("\n \n ------------------------------------------------------------------------ \n \n \n \n \n")
                XCTAssertNotEqual(0, allLists.count, "The player has not any list")
            }
        }
    }
    
    func testDeleteList() {
        service.createListWith(name: MockData.PlayersList.name, completion: { (playerList) in
            XCTAssertNotNil(playerList, "There was a problem creating a list with name: \(MockData.PlayersList.name)")
        })
    
        service.deleteList(list: PlayerList(name: MockData.PlayersList.name)) { (success) in
            XCTAssertTrue(success, "There was a problem deleting a list with name: \(MockData.PlayersList.name)")
        }
    }
}
