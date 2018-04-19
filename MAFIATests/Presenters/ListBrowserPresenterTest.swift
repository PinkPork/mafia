//
//  ListBrowserPresenterTest.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 4/3/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import XCTest

class ListBrowserPresenterTest: BasePresenterTest {

    let mockListPlayersView = MockListPlayersView()
    var mockListPlayerService: MockListService!
    var listPlayersPresenterTest: ListBrowserPresenter!
    
    override func setUp() {
        super.setUp()
        mockListPlayerService = MockListService(lists: lists)
        listPlayersPresenterTest = ListBrowserPresenter(view: mockListPlayersView, playerListService: mockListPlayerService)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testShouldListPlayers() {
        listPlayersPresenterTest.showListPlayers()
        XCTAssert(mockListPlayersView.setListPlayersCalled)
    }

    func testCreateList() {
        listPlayersPresenterTest.createList(withName: "Test")
        XCTAssert(mockListPlayersView.addNewListCalled)
    }

    func testDeleteList() {
        listPlayersPresenterTest.deleteList(playersList: lists.first!, indexPath: IndexPath(item: 0, section: 0))
        XCTAssert(mockListPlayersView.deleteListCalled)
    }

    func testSelectList() {
        listPlayersPresenterTest.selectList(list: lists.first!)
        XCTAssert(GameManager.currentGame.isSelectedListPlayers)
    }
}
