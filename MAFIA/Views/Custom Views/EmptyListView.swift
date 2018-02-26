//
//  EmptyListView.swift
//  MAFIA
//
//  Created by Hugo Bernal on Feb/24/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol EmptyListViewDelegate: class {
    func goToAction()
}

class EmptyListView: UIView {
    
    // MARK: - Properties
    
    let gradient = CAGradientLayer()
    
    weak var delegate: EmptyListViewDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let myView = Bundle.main.loadNibNamed("EmptyListView", owner: self, options: nil)?.first as! UIView
        
        myView.frame = self.bounds
        
        addSubview(myView)
        
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        gradient.frame = buttonOutlet.bounds
        
    }
    
    // MARK: - Methods
    
    func setup() {
        
        gradient.colors = [Utils.Palette.Basic.red.cgColor, Utils.Palette.Basic.black.cgColor]
        gradient.cornerRadius = 28
        
        buttonOutlet.layer.insertSublayer(gradient, at: 0)
        buttonOutlet.setTitleColor(Utils.Palette.Basic.white, for: .normal)
        
        titleLabel.font = UIFont(name: "PAPYRUS_FONT".localized(), size: 36.0)
        titleLabel.textColor = Utils.Palette.Basic.gray
        messageLabel.font = UIFont(name: "PAPYRUS_FONT".localized(), size: 14.0)
        
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonAction(_ sender: Any) {
        
        delegate?.goToAction()
        
    }
    

}
