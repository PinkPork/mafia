//
//  PlayersListTableViewCell.swift
//  MAFIA
//
//  Created by Hugo Bernal on Jan/12/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol ListBrowserTableViewCellDelegate: class {
    func startGame(withList list: List)
}

class ListBrowserTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playersListForGameButton: UIButton!

    // MARK: - Vars & Constants

    static var identifier: String {
        return String(describing: self)
    }

    private var list: List?
    weak var delegate: ListBrowserTableViewCellDelegate?

    
    // MARK: - IBActions
    
    @IBAction func usePlayersListForGameButton(_ sender: Any) {
        if let list = list {
            delegate?.startGame(withList: list)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playersListForGameButton.setTitle("USE_PLAYERS_LIST_BUTTON_TITLE".localized(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Methods
    
    func setCellData(list: List) {
        self.list = list
        nameLabel.text = list.name
    }
    
}
