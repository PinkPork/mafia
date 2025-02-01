//
//  MockListPlayersView.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 4/4/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import UIKit

class MockListPlayersView: ListBrowserView {

    var setListPlayersCalled = false
    var addNewListCalled = false
    var deleteListCalled = false
    var didShowAlert = false

    func setListPlayers(listPlayers: [PlayerList]) {
        setListPlayersCalled = true
    }

    func addNewList(listPlayer: PlayerList) {
        addNewListCalled = true
    }

    func deleteList(listPlayer: PlayerList, indexPath: IndexPath) {
        deleteListCalled = true
    }

    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style, completionFirstAction: (() -> Void)?) {
        didShowAlert = true
    }
}
