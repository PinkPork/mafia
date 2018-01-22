//
//  PlayerTableViewCell.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/19/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleImageView: UIImageView!
    
    // MARK: - Vars & Constants
    static let nib: String = "PlayerTableViewCell"
    static let identifier: String = "PlayerCell"
    var player: Player!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.contentView.backgroundColor = selected ? UIColor.red : UIColor.white
    }
    
    // MARK: - Methods
    
    func setCellData(player: Player) {
        self.player = player
        self.nameLabel.text = player.name
        self.roleImageView.image = UIImage(named: "\(player.role.imageDescription)")
        self.contentView.backgroundColor = GameManager.currentGame.checkForKilledPlayers(player: player) ? UIColor.red : UIColor.white
    }
    
}
