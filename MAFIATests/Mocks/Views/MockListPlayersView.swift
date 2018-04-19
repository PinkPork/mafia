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

    func setListPlayers(listPlayers: [List]) {
        setListPlayersCalled = true
    }

    func addNewList(listPlayer: List) {
        addNewListCalled = true
    }

    func deleteList(listPlayer: List, indexPath: IndexPath) {
        deleteListCalled = true
    }

    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertControllerStyle, completionFirstAction: (() -> Void)?) {
        didShowAlert = true
    }
}
