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

class DetailListPlayersService: XCTestCase {
    
    var service: DetailListPlayerService!
    
    override func setUp() {
        super.setUp()
        service = DetailListPlayerService()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreatePlayList() {
        let playersListService = PlayersListService()
        playersListService.getPlayers { (playersList) in
            if let firstList = playersList?.first {
                if let players = firstList.players {
                    if let arrayPlayers = Array(players) as? [PlayerMO] {
                        if let firstPlayer = arrayPlayers.first {
                            print(firstPlayer.name!)
                            self.service.remove(firstPlayer, fromList: firstList) { (success) in
                                print(arrayPlayers.first?.name)
                            }
                        }
                    }
                }
            }
        }
        //        playerService.getPlayers { (players) in
        //            if let players = players {
        //                self.service.createPlayersListWith(name: MockData.PlayersList.name, players: players, completion: { (playerList) in
        //                    XCTAssertNotNil(playerList, "There was a problem creating a list with name: \(MockData.PlayersList.name)")
        //                })
        //            }
        //        }
    }
    
    func testGetAllLists() {
//        service.getPlayers { (playersList) in
//            XCTAssertNotNil(playersList, "The players list is empty")
//            if let allLists = playersList {
//                print("\n \n ------------------------------------------------------------------------ \n \n")
//                for list in allLists {
//                    print("\n El nombre de la lista es: " + list.name! + "\n")
//                    for player in list.players! {
//                        let newp = player as! PlayerMO
//                        print(" * Jugador: " + newp.name!)
//                    }
//                }
//                print("\n \n ------------------------------------------------------------------------ \n \n \n \n \n")
//                XCTAssertNotEqual(0, allLists.count, "The player has not any list")
//            }
//        }
    }
}
