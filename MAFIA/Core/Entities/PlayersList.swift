//
//  PlayersList.swift
//  MAFIA
//
//  Created by Santiago Carmona gonzalez on 1/18/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

protocol PlayersList: class {
    var name: String { get set }
    var players: [Player] { get set }
}


class RawPlayersList: PlayersList {
    var name: String
    var players: [Player]
    
    init(name: String, players: [Player] = [Player]()) {
        self.name = name
        self.players = players
    }
}
