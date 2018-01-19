//
//  MockPlayerService.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 1/9/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import Foundation

class MockPlayerService: PlayerService {
    
    private let players: [Player]
    
    init(players: [Player]) {
        self.players = players
    }
    
    override func savePlayer(name: String, completion: (Player?) -> Void) {
        completion(players.first)
    }
    
    override func getPlayer(withName name: String, completion: (Player?) -> Void) {
        completion(players.first(where: { (player) -> Bool in
            return player.name == name
        }))
    }
    
    override func getPlayers(completion: @escaping GetPlayersCompletion) {
        completion(players)
    }
}
