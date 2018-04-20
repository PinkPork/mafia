//
//  MenuViewController.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/27/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func performSegue(withIdentifier identifier: String)
}

class MenuViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!

    // MARK: - Vars & Constants

    var menuOptions: [MenuOptions] = []
    var presenter: MenuPresenter!
    weak var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackgroundColorView()
        setupTableView()
        setupCloseTapGesture()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = MenuPresenter(view: self)
        presenter.displayOptions()
        logoImageView.image = UIImage(named: "LogoWhite")
    }

    private func setupBackgroundColorView() {
        backgroundColorView.addGradient(colors: Utils.Palette.Basic.black.cgColor, Utils.Palette.Basic.red.cgColor)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.contentInset = UIEdgeInsets(top: logoImageView.frame.maxY, left: 0, bottom: 0, right: 0)
        let nib = UINib(nibName: MenuTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MenuTableViewCell.identifier)
    }

    private func setupCloseTapGesture() {
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        backView.addGestureRecognizer(closeTapGesture)
    }

    @objc func closeMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    func goTo(menuOption option: MenuOptions) {
        var segue: String!
        
        switch option {
        case .PlayersList:
            segue = Segues.Menu.playersList
        default:
            return
        }
        closeMenu()
        self.delegate?.performSegue(withIdentifier: segue)
    }
    
}

// MARK: - MenuView protocol conformance

extension MenuViewController: MenuView {
    func setMenu(options: [MenuOptions]) {
        menuOptions = options
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource

extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier)

        guard let menuCell = cell as? MenuTableViewCell else {
            assertionFailure("Unexpected cell of type: \(type(of: cell))")
            return UITableViewCell()
        }
        
        menuCell.setCell(title: menuOptions[indexPath.row].title)
        return menuCell
    }
}

// MARK: - TableView Delegate

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = menuOptions[indexPath.row]
        
        goTo(menuOption: selectedOption)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
