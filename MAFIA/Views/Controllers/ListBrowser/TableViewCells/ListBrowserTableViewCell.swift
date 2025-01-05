//
//  PlayersListTableViewCell.swift
//  MAFIA
//
//  Created by Hugo Bernal on Jan/12/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol ListBrowserTableViewCellDelegate: AnyObject {
    func startGame(withList list: PlayerList)
}

class ListBrowserTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playersListForGameButton: UIButton!

    // MARK: - Vars & Constants

    static var identifier: String {
        return String(describing: self)
    }

    private var list: PlayerList?
    weak var delegate: ListBrowserTableViewCellDelegate?

    // MARK: - IBActions
    
    @IBAction func usePlayersListForGameButton(_ sender: Any) {
        if let list = list {
            delegate?.startGame(withList: list)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playersListForGameButton.setTitle("USE_PLAYERS_LIST_BUTTON_TITLE".localized(), for: UIControl.State.normal)
    }
    
    // MARK: Methods
    
    func setCellData(list: PlayerList) {
        self.list = list
        nameLabel.text = list.name
    }
    
}
