//
//  MockListService.swift
//  MAFIATests
//
//  Created by Santiago Carmona Gonzalez on 4/4/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

@testable import MAFIA
import Foundation

class MockListService: ListService {
    private let lists: [PlayerList]

    init(lists: [PlayerList]) {
        self.lists = lists
    }

    override func createListWith(name: String, players: [Player], completion: (PlayerList?) -> Void) {
        completion(lists.first)
    }

    override func getLists(completion: @escaping GetListsCompletion) {
        completion(lists)
    }

    override func getList(withName name: String, completion: (PlayerList?) -> Void) {
        completion(lists.first(where:  { $0.name == name }))
    }

    override func deleteList(list: PlayerList, completion: (Bool) -> Void) {
        completion(true)
    }
}
