//
//  PlayersListServiceTests.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import XCTest
@testable import MAFIA



class PlayersListServiceTests: BaseTest {
    
    var service: PlayersListService!
    
    override func setUp() {
        super.setUp()
        service = PlayersListService()        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreatePlayList() {
        service.createPlayersListWith(name: MockData.PlayersList.name, completion: { (playerList) in
            XCTAssertNotNil(playerList, "There was a problem creating a list with name: \(MockData.PlayersList.name)")
        })
    }
    
    func testCreatePlayListWithUsers() {
    }
    
    func testGetAllLists() {
        for list in MockData.PlayersList.rawLists {
            service.createPlayersListWith(name: list, completion: { (playerList) in
                XCTAssertNotNil(playerList, "There was a problem creating a list with name: \(MockData.PlayersList.name)")
            })
        }
        
        service.getPlayers { (playersList) in
            XCTAssertNotNil(playersList, "The players list is empty")
            if let allLists = playersList {
                print("\n \n ------------------------------------------------------------------------ \n \n")
                for list in allLists {
                    print("\n El nombre de la lista es: " + list.name + "\n")
                    for player in list.players! {
                        let newp = player as! PlayerMO
                        print(" * Jugador: " + newp.name)
                    }
                }
                print("\n \n ------------------------------------------------------------------------ \n \n \n \n \n")
                XCTAssertNotEqual(0, allLists.count, "The player has not any list")
            }
        }
    }
}
