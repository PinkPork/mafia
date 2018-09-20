//
//  MockGameView.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 1/9/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import UIKit

class MockGameView: GameView {
    
    var setPlayersCalled = false
    var addNewPlayerCalled = false
    var deletePlayerCalled = false
    var updateGameUICalled = false
    var endGameCalled = false
    var restartGameCalled = false
    var didShowAlert = false
    
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

    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style, completionFirstAction: (() -> Void)?) {
        didShowAlert = true
    }
}
