//
//  PlayerServiceTest.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 12/28/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import XCTest
@testable import MAFIA

class PlayerServiceTest: BaseTest {
    
    var service: PlayerService!
    
    override func setUp() {
        super.setUp()
        service = PlayerService()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreatePlayer() {
        service.savePlayer(name: MockData.Player.name) { (player) in
            XCTAssertNotNil(player, "There was an error creating a player with name: \(name)")
        }
    }
    
    func testLoadPlayer() {
        testCreatePlayer()
        service.getPlayer(withName: MockData.Player.name) { (player) in
            XCTAssertNotNil(player, "There was an error loading a player named : \(MockData.Player.name)")
        }
    }
    
    func testLoadAllPlayers() {
        for player in MockData.Player.rawPlayers {
            service.savePlayer(name: player) { (player) in
                XCTAssertNotNil(player, "There was an error creating a player with name: \(name)")
            }
        }
        service.getPlayers { (players) in
            if let players = players {
                print("--------------------------------------------------------------------- \n")
                print("Hay un total de \(players.count) jugadores registrados en la app y sus nombres son: \n")
                for player in players {
                    print("* Jugador: \(player.name) \n")
                }
                print("--------------------------------------------------------------------- \n")
                XCTAssertNotEqual(0, players.count, "There is not any player saved")
            }
            XCTAssertNotNil(players, "There was an error loading all players")
        }
    }
    
    func testDeletePlayer() {
        testCreatePlayer()
        service.getPlayer(withName: MockData.Player.name) { (player) in
            XCTAssertNotNil(player, "There was an error loading a player named : \(MockData.Player.name)")
            
            service.deletePlayer(player: player!, completion: { (success) in
                XCTAssertTrue(success, "There was a problem deleting the player named: \(player!.name)")
            })
        }
    }
}

