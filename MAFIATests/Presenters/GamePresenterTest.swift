//
//  GamePresenterTest.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 1/9/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import XCTest

class GamePresenterTest: XCTestCase {
    
    let mockGameView = MockGameView()
    var mockPlayerService: MockPlayerService!
    var gamePresenterTest: GamePresenter!
    
    override func setUp() {
        super.setUp()
        mockPlayerService = MockPlayerService(players: getMockPlayers())
        let selectedPlayerList = PlayersListMO(entity: CoreDataConnection.shared.getEntity(withName: PlayersListMO.entityName)!, insertInto: CoreDataConnection.shared.managedContext)
//        selectedPlayerList.players =  getMockPlayers().toNSSet()
        GameManager.currentGame.setSelectedList(listPlayers: PlayersListMO.parse(playersList: selectedPlayerList))
        gamePresenterTest = GamePresenter(view: mockGameView, playerService: mockPlayerService)
    }
    
    func testShouldShowPlayers() {
        gamePresenterTest.showPlayers()
        XCTAssertTrue(mockGameView.setPlayersCalled)
    }
    
    func testRefreshRoles() {
        var players = getMockPlayers()
        players = gamePresenterTest.refreshRoles(players: players)
        
        
        let playersWithRoleChanged = players.filter { $0.role != .none }
        let mafiaPlayers = playersWithRoleChanged.filter { $0.role == .mafia }
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
        XCTAssertNotEqual(0, playersWithRoleChanged.count,"""
            There was a shuffle problem
            minimun players: \(GameRules.minimumPlayers)
            players: \(players.count)
            """
        )
    }
    
    /// Gets 5 mock players with different name and the same role **Role.none** for test
    /// - returns: An Array `PlayerMO` with mockData
    private func getMockPlayers() -> [Player] {
        return MockData.Player.rawPlayers.map({ (name) -> Player in
           return RawPlayer(name: name)
        })
    }
}
