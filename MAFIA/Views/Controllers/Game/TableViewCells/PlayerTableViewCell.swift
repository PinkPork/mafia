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
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var cellBorderView: UIView!
    @IBOutlet weak var bulletImageView: UIImageView!
    
    
    // MARK: - Vars & Constants
    static let nib: String = "PlayerTableViewCell"
    static let identifier: String = "PlayerCell"
    var player: Player!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setCellBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.contentView.backgroundColor = selected ? UIColor.red : UIColor.white
    }
    
    // MARK: - Methods
    
    func setCellData(player: Player) {
        self.player = player
        self.nameLabel.text = player.name
        self.roleLabel.text = player.role.roleDescription
        self.roleImageView.image = GameManager.currentGame.checkForKilledPlayers(player: player) ? UIImage(named: "deselected_\(player.role.imageDescription)") : UIImage(named: "\(player.role.imageDescription)")
        self.nameLabel.textColor = GameManager.currentGame.checkForKilledPlayers(player: player) ? Utils.Palette.Basic.veryLightGrey : Utils.Palette.Basic.lightGray
        self.roleLabel.textColor = GameManager.currentGame.checkForKilledPlayers(player: player) ? Utils.Palette.Basic.veryLightGrey : Utils.Palette.Basic.lightGray
        self.bulletImageView.isHidden = GameManager.currentGame.checkForKilledPlayers(player: player) ? false : true
    }
    
    func setCellBorder() {
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = CGPath(rect: cellBorderView.bounds, transform: &transform)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = Utils.Palette.Basic.lightGray.cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = cellBorderView.bounds
        cellBorderView.layer.addSublayer(borderLayer)
        
    }
    
}
