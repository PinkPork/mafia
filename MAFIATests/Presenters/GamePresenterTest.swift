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
    
    override func setUp() {
        super.setUp()
        mockPlayerService = MockPlayerService(players: getMockPlayers())
        let selectedPlayerList = PlayersListMO(entity: CoreDataConnection.shared.getEntity(withName: PlayersListMO.entityName)!, insertInto: CoreDataConnection.shared.managedContext)
        selectedPlayerList.players = NSSet(array: getMockPlayers())
        GameManager.currentGame.setSelectedList(listPlayers: selectedPlayerList)
    }
    
    func testShouldSetPlayer() {
        let gamePresenterTest = GamePresenter(view: mockGameView, playerService: mockPlayerService)
        gamePresenterTest.showPlayers()
        XCTAssertTrue(mockGameView.setPlayersCalled)
    }
    
    private func getMockPlayers() -> [PlayerMO] {
        return MockData.Player.rawPlayers.map({ (name) -> PlayerMO in
            let playerEntity = CoreDataConnection.shared.getEntity(withName: PlayerMO.entityName)
            let playerMO = PlayerMO(entity: playerEntity!, insertInto: CoreDataConnection.shared.managedContext)
            playerMO.name = name
            return playerMO
        })
    }
}
