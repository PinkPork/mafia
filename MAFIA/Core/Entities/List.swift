//
//  PlayerList.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

final class PlayerList: Equatable {
    let name: String
    var players: [Player]
    
    init(name: String, players: [Player] = [Player]()) {
        self.name = name
        self.players = players
    }

    static func == (lhs: PlayerList, rhs: PlayerList) -> Bool {
        return lhs.name == rhs.name && lhs.players == rhs.players
    }
}
