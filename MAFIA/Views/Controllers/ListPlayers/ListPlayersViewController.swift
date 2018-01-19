//
//  ListPlayersViewController.swift
//  MAFIA
//
//  Created by Hugo Bernal on Dec/29/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class ListPlayersViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars & Constants
    
    private var listPlayers: [PlayersList] = [PlayersList]()
    private var presenter: ListPlayersPresenter!
    weak var gamePresenter: GamePresenter!
    private var addListAction: UIAlertAction?
    private let listCellIndetifier: String = "PlayersListCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
    }
    
    // MARK: - IBActions
    
    @IBAction func addLists(_ sender: Any) {
        showAddListPopUp()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = ListPlayersPresenter(view: self)
        presenter.showListPlayers()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "PlayersListTableViewCell", bundle: nil), forCellReuseIdentifier: listCellIndetifier)
    }
    
    private func updateAddButtonState(text: String?) {
        let emptyText = text ?? ""
        addListAction?.isEnabled = !emptyText.isEmpty
    }
    
    private func showAddListPopUp() {
        let alertController = UIAlertController(title: "ADD_LIST_TITLE".localized(), message: "ADD_LIST_MESSAGE".localized(), preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.delegate = self
            textField.becomeFirstResponder()
        }
        addListAction = UIAlertAction(title: "ADD_ACTION".localized(), style: .default) { (action) in
            let textField = alertController.textFields?.first
            
            guard let listName = textField?.text else { return }
            self.presenter.createList(withName: listName, errorCompletion: self.showAddListPopUp)
        }
        
        let cancelButton = UIAlertAction(title: "CANCEL_ACTION".localized(), style: .cancel)
        
        alertController.addAction(addListAction!)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailListPlayersViewController {
            destination.listPlayers = sender as? RawPlayersList
        }
    }
}

// MARK: - ListPlayersView protocol conformance

extension ListPlayersViewController: ListPlayersView {
    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertControllerStyle) {
        self.presentAlert(title: title, message: message, preferredStyle: preferredStyle)
    }
    
    func deleteList(listPlayer: PlayersList, indexPath: IndexPath) {
        listPlayers.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func addNewList(listPlayer: PlayersList) {
        listPlayers.append(listPlayer)
        tableView.reloadData()
        presentAlert(title: "LIST_ADDED_TITLE".localized(), message: String.localizedStringWithFormat("LIST_ADDED_MESSAGE".localized(), listPlayer.name), preferredStyle: .actionSheet)
    }
    
    func setListPlayers(listPlayers: [PlayersList]) {
        self.listPlayers = listPlayers
        tableView.reloadData()
    }
    
}

// MARK: - PlayersListTableViewCellDelegate protocol conformance

extension ListPlayersViewController: PlayersListTableViewCellDelegate {
    func startGame(withList list: PlayersList) {
        presenter.selectList(list: list)
        gamePresenter.restartGame()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView DataSource

extension ListPlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listCellIndetifier, for: indexPath)  as! PlayersListTableViewCell
        let list = listPlayers[indexPath.row]
        cell.setCellData(list: list)
        cell.delegate = self
        return cell
    }
}

// MARK: - TableView Delegate

extension ListPlayersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = listPlayers[indexPath.row]
        self.performSegue(withIdentifier: Segues.detailListPlayers, sender: selectedList)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: .destructive, title: "DELETE_ACTION".localized(), handler: { [weak self] (_, indexPath) in
            if let strongSelf = self {
                strongSelf.presenter.deleteList(playersList: strongSelf.listPlayers[indexPath.row], indexPath: indexPath)
            }
        })]
    }
}

// MARK: - TextField Delegate

extension ListPlayersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateAddButtonState(text: textField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addListAction?.isEnabled = false
    }
}


