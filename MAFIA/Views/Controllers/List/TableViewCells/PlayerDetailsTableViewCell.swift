//
//  PlayerDetailsTableViewCell.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 4/2/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class PlayerDetailsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var decorativeImage: UIImageView!
    @IBOutlet weak var bottomBorderView: UIView!

    // MARK: - Vars & Constants

    static var identifier: String {
        return String(describing: self)
    }

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Methods

    private func setup() {
        nameLabel.font = UIFont(name: "Helvetica", size: 18)
        nameLabel.textColor = Utils.Palette.Basic.lightGray
        bottomBorderView.backgroundColor = Utils.Palette.Basic.darkBlue
    }

    func setCell(title: String) {
        nameLabel.text = title
    }

}
