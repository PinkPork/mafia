//
//  PlayersListServiceTests.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import XCTest
@testable import MAFIA



class PlayersListServiceTests: XCTestCase {
    
    var service: PlayersListService!
    
    override func setUp() {
        super.setUp()
        service = PlayersListService()        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreatePlayList() {
        let players = try! CoreDataConnection.shared.fetchRequest(entityName: PlayerMO.entityName) as! [PlayerMO]
        service.createPlayersListWith(name: MockData.PlayersList.name, players: players, completion: { (playerList) in
            XCTAssertNotNil(playerList, "There was a problem creatin a list with name: \(MockData.PlayersList.name)")
        })
    }
    
    func testGetAllLists() {
        let allLists = try! CoreDataConnection.shared.fetchRequest(entityName: PlayersListMO.entityName) as! [PlayersListMO]
        for list in allLists {
            print("------ El nombre de la lista es: " + list.name!)
            for player in list.players! {
                let newp = player as! PlayerMO
                print("----------- Jugador: " + newp.name!)
            }
        }
        
        XCTAssertNotEqual(0, allLists.count, "The player has not any list")
    }
}
