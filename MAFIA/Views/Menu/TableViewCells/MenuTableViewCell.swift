//
//  MenuTableViewCell.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/22/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBorder: UIView!

    // MARK: - Vars & Constants

    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        titleLabel.font = UIFont(name: "PAPYRUS_FONT".localized(), size: 24)
        titleLabel.textColor = Utils.Palette.Menu.textColor
        bottomBorder.backgroundColor = Utils.Palette.Menu.gray
    }

    func setCell(title: String) {
        titleLabel.text = title
    }
    
}
