//
//  EmptyListView.swift
//  MAFIA
//
//  Created by Hugo Bernal on Feb/24/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol EmptyListViewDelegate: AnyObject {
    func goToAction()
}

class EmptyListView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var buttonOutlet: UIButton!
    
    // MARK: - Properties
    weak var delegate: EmptyListViewDelegate?

    // MARK: - Life Cycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let myView = Bundle.main.loadNibNamed("EmptyListView", owner: self, options: nil)?.first as! UIView
        myView.frame = self.bounds
        addSubview(myView)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Methods
        
    func set(titleLabel title: String) {
        titleLabel.text = title
    }
    
    func set(messageLabel message: String) {
        messageLabel.text = message
    }
    
    func set(buttonTitle title: String) {
        buttonOutlet.setTitle(title, for: .normal)
    }
    
    // MARK: - IBActions
    
    @IBAction private func buttonAction(_ sender: Any) {
        delegate?.goToAction()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        setupButtonOutlet()
        setupTitleLabel()
        setupMessageLabel()
    }
    
    private func setupButtonOutlet() {
        buttonOutlet.layer.cornerRadius = 28
        buttonOutlet.addGradient()
        buttonOutlet.setTitleColor(Utils.Palette.Basic.white, for: UIControl.State.normal)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont(name: "PAPYRUS_FONT".localized(), size: 36.0)
        titleLabel.textColor = Utils.Palette.Basic.gray
    }
    
    private func setupMessageLabel() {
        messageLabel.font = UIFont(name: "PAPYRUS_FONT".localized(), size: 14.0)
    }
}
