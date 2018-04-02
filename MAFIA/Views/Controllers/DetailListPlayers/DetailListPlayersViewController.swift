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
    @IBOutlet weak var emptyView: EmptyListView!
    @IBOutlet weak var addFromOtherListButton: UIButton!
    
    // MARK: - Vars & Constants

    private let gradient = CAGradientLayer()
    private var presenter: DetailListPlayersPresenter!
    private var addPlayerAction: UIAlertAction?
    private var isHiddenEmptyView: Bool {
        return !listPlayers.players.isEmpty
    }
    
    weak var listPlayers: RawPlayersList!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAddFromOtherListButton()
        setupEmptyView()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gradient.frame = addFromOtherListButton.bounds
    }
    
    // MARK: - IBActions
    
    @IBAction func addPlayer(_ sender: Any) {
        showAddPlayerPopUp()
    }
    
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = DetailListPlayersPresenter(view: self)
        
        guard let title = listPlayers?.name else { return }
        self.navigationItem.title = title
    }

    private func setupEmptyView() {
        emptyView.set(titleLabel: "EMPTY_DETAIL_LIST_PLAYERS".localized())
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.register(
            UINib(nibName: PlayerDetailsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: PlayerDetailsTableViewCell.identifier
        )
    }
    
    private func updateAddButtonState(text: String?) {
        // Disable the Add button if the text field is empty.
        let emptyText = text ?? ""
        addPlayerAction?.isEnabled = !emptyText.isEmpty
    }
    
    private func showAddPlayerPopUp() {
        let alertController = UIAlertController(title: "ADD_PLAYER_TITLE".localized(), message: "ADD_PLAYER_MESSAGE".localized(), preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.delegate = self
            textField.becomeFirstResponder()
        }
        
        addPlayerAction = UIAlertAction(title: "ADD_ACTION".localized(), style: .default) { (action) in
            let textField = alertController.textFields?.first
            guard let playerName = textField?.text, !playerName.isEmpty else { return }
            guard let list = self.listPlayers else { return }
            self.presenter.addPlayer(withName: playerName, toList: list, errorCompletion: self.showAddPlayerPopUp)
        }
        
        let cancelButton = UIAlertAction(title: "CANCEL_ACTION".localized(), style: .cancel)
        
        alertController.addAction(addPlayerAction!)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }

    private func setupAddFromOtherListButton() {
        addFromOtherListButton.layer.cornerRadius = 28
        addFromOtherListButton.addGradient()
        addFromOtherListButton.setTitle("ADD_FROM_OTHER_LIST".localized(), for: .normal)
        addFromOtherListButton.setTitleColor(Utils.Palette.Basic.white, for: .normal)
        addFromOtherListButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}

// MARK: - DetailListPlayersView protocol conformace

extension DetailListPlayersViewController: DetailListPlayersView {
   
    func addNewPlayer(player: Player) {
        listPlayers.players.append(player)
        tableView.reloadData()
    }
    
    func deletePlayer(player: Player, indexPath: IndexPath) {
        listPlayers.players.remove(at: indexPath.row)
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource

extension DetailListPlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Displays the empty view if there are not any player in the list.
        emptyView.isHidden = isHiddenEmptyView

        return listPlayers.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerDetailsTableViewCell.identifier, for: indexPath)

        guard let playerDetailsCell = cell as? PlayerDetailsTableViewCell else {
            assertionFailure("Unexpected cell of type: \(type(of: cell))")
            return cell
        }

        let player = listPlayers.players[indexPath.row]
        playerDetailsCell.setCell(title: player.name)

        return playerDetailsCell
    }
}

// MARK: - TableView Delegate

extension DetailListPlayersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE_ACTION".localized()) {
            [weak self] (contextAction: UIContextualAction, sourceView: UIView, completion: (Bool) -> Void) in
            if let strongSelf = self {
                guard let list = strongSelf.listPlayers else { return }
                strongSelf.presenter.deletePlayer(player: strongSelf.listPlayers.players[indexPath.row], list: list, indexPath: indexPath)
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
