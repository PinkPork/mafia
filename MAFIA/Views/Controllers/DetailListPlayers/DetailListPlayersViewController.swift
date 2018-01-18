//
//  DetailListPlayersViewController.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/5/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class DetailListPlayersViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars & Constants
    
    private var players: [PlayerMO] = [PlayerMO]()
    private var presenter: DetailListPlayersPresenter!
    private var addPlayerAction: UIAlertAction?
    
    weak var listPlayers: PlayersListMO?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    // MARK: - IBActions
    
    @IBAction func addPlayer(_ sender: Any) {
        
        let alertController = UIAlertController(title: "ADD_PLAYER_TITLE".localized(), message: "ADD_PLAYER_MESSAGE".localized(), preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.delegate = self
            textField.becomeFirstResponder()
        }
        
        addPlayerAction = UIAlertAction(title: "ADD_ACTION".localized(), style: .default) { (action) in
            let textField = alertController.textFields?.first
            guard let playerName = textField?.text, !playerName.isEmpty else { return }
            guard let list = self.listPlayers else { return }
            if self.players.filter({ $0.name == playerName }).count == 0 {
                self.presenter.addPlayer(withName: playerName, list: list)
                self.presentActionSheet(title: "PLAYER_ADDED_TITLE".localized(), message: String.localizedStringWithFormat("PLAYER_ADDED_MESSAGE".localized(), playerName))
            } else {
                self.presentActionSheet(title: "PLAYER_ALREADY_ADDED_TITLE".localized(), message: "PLAYER_ALREADY_ADDED_MESSAGE".localized())
            }
        }
        let cancelButton = UIAlertAction(title: "CANCEL_ACTION".localized(), style: .cancel)
        
        alertController.addAction(addPlayerAction!)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = DetailListPlayersPresenter(view: self)
        if  let playersFromList: [PlayerMO] = listPlayers?.players?.toArray() {
            players = playersFromList
        }
        guard let title = listPlayers?.name else { return }
        self.navigationItem.title = title
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func updateAddButtonState(text: String?) {
        // Disable the Add button if the text field is empty.
        let emptyText = text ?? ""
        addPlayerAction?.isEnabled = !emptyText.isEmpty
    }
    
}

// MARK: - DetailListPlayersView protocol conformace

extension DetailListPlayersViewController: DetailListPlayersView {
    
    func addNewPlayer(player: PlayerMO) {
        self.players.append(player)
        tableView.reloadData()
    }
    
    func deletePlayer(player: PlayerMO, indexPath: IndexPath) {
        players.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
}

// MARK: - TableView DataSource

extension DetailListPlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        return cell
    }
}

// MARK: - TableView Delegate

extension DetailListPlayersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE_ACTION") {
            [weak self] (contextAction: UIContextualAction, sourceView: UIView, completion: (Bool) -> Void) in
            if let strongSelf = self {
                guard let list = strongSelf.listPlayers else { return }
                strongSelf.presenter.deletePlayer(player: strongSelf.players[indexPath.row], list: list, indexPath: indexPath)
                completion(true)
            } else {
                completion(false)
            }
        }
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
}

// MARK: - TextField Delegate

extension DetailListPlayersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateAddButtonState(text: textField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addPlayerAction?.isEnabled = false
    }
}
