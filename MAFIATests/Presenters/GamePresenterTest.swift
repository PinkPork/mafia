//
//  GamePresenterTest.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 1/9/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import XCTest

class GamePresenterTest: BasePresenterTest {
    
    let mockGameView = MockGameView()
    var mockPlayerService: MockPlayerService!
    var gamePresenterTest: GamePresenter!
    
    override func setUp() {
        super.setUp()
        mockPlayerService = MockPlayerService(players: getMockPlayers())
        gamePresenterTest = GamePresenter(view: mockGameView, playerService: mockPlayerService)
        let selectedPlayerList = RawList(name: MockData.PlayersList.name, players: getMockPlayers())
        GameManager.currentGame.setSelectedList(listPlayers: selectedPlayerList)
    }
    
    func testShouldShowPlayers() {
        gamePresenterTest.showPlayers()
        XCTAssertTrue(mockGameView.setPlayersCalled)
    }

    func testAddNewPlayer() {
        gamePresenterTest.addPlayerInCurrentGame(withName: "Fulano")
        XCTAssert(mockGameView.addNewPlayerCalled)
    }

    func testDeletePlayer() {
        gamePresenterTest.deletePlayer(player: GameManager.currentGame.playersPlaying!.first!, indexPath: IndexPath(row: 0, section: 0))
        XCTAssert(mockGameView.deletePlayerCalled)
    }

    func testKillPlayer() {
        let eliminatedPlayers = GameManager.currentGame.numberOfEliminatedPlayers
        gamePresenterTest.kill(player: GameManager.currentGame.playersPlaying!.first!)
        XCTAssert(mockGameView.endGameCalled)
        XCTAssert(mockGameView.updateGameUICalled)
        XCTAssertLessThan(eliminatedPlayers, GameManager.currentGame.numberOfEliminatedPlayers)
    }

    func testRevivePlayer() {
        gamePresenterTest.kill(player: GameManager.currentGame.playersPlaying!.first!)
        let alivePlayers = GameManager.currentGame.numberOfAlivePlayers
        gamePresenterTest.revivePlayer(player: GameManager.currentGame.playersPlaying!.first!)        
        XCTAssert(mockGameView.updateGameUICalled)
        XCTAssertGreaterThan(GameManager.currentGame.numberOfAlivePlayers, alivePlayers)
    }
    
    func testRefreshRoles() {
        var players = getMockPlayers()
        players = gamePresenterTest.refreshRoles(players: players)
        
        let playersWithRoleChanged = players.filter { $0.role != .none }
        let mafiaPlayers = playersWithRoleChanged.filter { $0.role == .mob }
        let kingPlayer = playersWithRoleChanged.filter { $0.role == .king }
        let sheriffPlayer = playersWithRoleChanged.filter { $0.role == .sheriff }
        let doctorPlayer = playersWithRoleChanged.filter { $0.role == .doctor }
        
        // - After shuffle the roles
        
        // Check that there is only one king on the game
        XCTAssertEqual(1, kingPlayer.count, "There are \(kingPlayer.count) kings on the game")
        
        // Check that there is only one sheriff on the game
        XCTAssertEqual(1, sheriffPlayer.count, "There are \(sheriffPlayer.count) sheriffs on the game")
        
        // Check that there is only one doctor on the game
        XCTAssertEqual(1, doctorPlayer.count, "There are \(doctorPlayer.count) doctors on the game")
        
        // Check that there are the third part of players playing as mafia
        XCTAssertEqual(playersWithRoleChanged.count / 3, mafiaPlayers.count, "There are \(mafiaPlayers.count) mafia on the game")
        
        // Check that all player has a role assigned and is different from none
        XCTAssertNotEqual(0, playersWithRoleChanged.count, """
            There was a shuffle problem
            minimun players: \(GameRules.minimumPlayers)
            players: \(players.count)
            """
        )
    }
}
