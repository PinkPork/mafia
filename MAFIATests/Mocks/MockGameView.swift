//
//  MockGameView.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 1/9/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import Foundation

class MockGameView: GameView {
    
    var setPlayersCalled = false
    var addNewPlayerCalled = false
    var deletePlayerCalled = false
    var updateGameUICalled = false
    var endGameCalled = false
    var restartGameCalled = false
    
    func setPlayers(players: [Player]) {
        setPlayersCalled = true
    }
    
    func addNewPlayer(player: Player) {
        addNewPlayerCalled = true
    }
    
    func deletePlayer(player: Player, indexPath: IndexPath) {
        deletePlayerCalled = true
    }
    
    func updateGameUI() {
        updateGameUICalled = true
    }
    
    func endGame(winner: Role) {
        endGameCalled = true
    }
    
    func restartGame() {
        restartGameCalled = true
    }
}
