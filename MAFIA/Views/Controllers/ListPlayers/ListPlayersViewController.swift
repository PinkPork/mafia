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
    
    private var listPlayers: [PlayersListMO] = [PlayersListMO]()
    private var presenter: ListPlayersPresenter!
    weak var gamePresenter: GamePresenter!
    private var addListAction: UIAlertAction?
    private let listCellIndetifier: String = "PlayersListCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
    @IBAction func addLists(_ sender: Any) {
        let alertController = UIAlertController(title: "ADD_LIST_TITLE".localized(), message: "ADD_LIST_MESSAGE".localized(), preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.delegate = self
        }
        addListAction = UIAlertAction(title: "ADD_LIST_ACTION".localized(), style: .default) { (action) in
            
            let textField = alertController.textFields?.first
            guard let listName = textField?.text, !listName.isEmpty else {
                print("No hay ningún texto")
                return
            }
            self.presenter.createList(withName: listName)
            
            
        }
        let cancelButton = UIAlertAction(title: "CANCEL_ACTION".localized(), style: .cancel)
        
        alertController.addAction(addListAction!)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
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
        // Disable the Add buttos if the text field is empty.
        let emptyText = text ?? ""
        addListAction?.isEnabled = !emptyText.isEmpty
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailListPlayersViewController {
            destination.listPlayers = sender as? PlayersListMO
        }
    }
}

// MARK: - ListPlayersView protocol conformance

extension ListPlayersViewController: ListPlayersView {
    func deleteList(listPlayer: PlayersListMO, indexPath: IndexPath) {
        listPlayers.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func addNewList(listPlayer: PlayersListMO) {
        listPlayers.append(listPlayer)
        tableView.reloadData()
    }
    
    func setListPlayers(listPlayers: [PlayersListMO]) {
        self.listPlayers = listPlayers
        tableView.reloadData()
    }
}

// MARK: - PlayersListTableViewCellDelegate protocol conformance

extension ListPlayersViewController: PlayersListTableViewCellDelegate {
    func startGame(withList list: PlayersListMO) {
        print("Se imprimió el botón")
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
//        presenter.selectList(list: selectedList)
//        gamePresenter.restartGame()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: .destructive, title: "DELETE_LIST_ACTION".localized(), handler: { [weak self] (_, indexPath) in
            if let strongSelf = self {
                strongSelf.presenter.deleteList(playersList: strongSelf.listPlayers[indexPath.row], indexPath: indexPath)
                // strongSelf.presenter.deletePlayer(player: strongSelf.playersToDisplay[indexPath.row], indexPath: indexPath)
            }
        })]
    }
}

// MARK: - TextField Delegate

extension ListPlayersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateAddButtonState(text: textField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        addListAction?.isEnabled = false
    }
}


