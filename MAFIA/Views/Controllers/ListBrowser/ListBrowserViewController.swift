//
//  ListBrowserViewController
//  MAFIA
//
//  Created by Hugo Bernal on Dec/29/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class ListBrowserViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars & Constants

    private let listCellIndetifier: String = "PlayersListCell"
    private var lists: [PlayerList] = [PlayerList]()
    private var presenter: ListBrowserPresenter!
    private var addListAction: UIAlertAction!

    weak var gamePresenter: GamePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupView()
    }
    
    // MARK: - IBActions
    
    @IBAction func addLists(_ sender: Any) {
        showAddListPopUp()
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        title = "MENU_PLAYERS_LIST".localized()
    }
    
    private func setupView() {
        presenter = ListBrowserPresenter(view: self)
        presenter.showListPlayers()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: ListBrowserTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: listCellIndetifier)
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
        
        alertController.addAction(addListAction)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ListViewController {
            destination.list = sender as? PlayerList
        }
    }
}

// MARK: - ListPlayersView protocol conformance

extension ListBrowserViewController: ListBrowserView {
    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style) {
        self.presentAlert(title: title, message: message, preferredStyle: preferredStyle)
    }
    
    func deleteList(listPlayer: PlayerList, indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func addNewList(listPlayer: PlayerList) {
        lists.append(listPlayer)
        tableView.reloadData()
    }
    
    func setListPlayers(listPlayers: [PlayerList]) {
        self.lists = listPlayers
        tableView.reloadData()
    }
    
}

// MARK: - PlayersListTableViewCellDelegate protocol conformance

extension ListBrowserViewController: ListBrowserTableViewCellDelegate {
    func startGame(withList list: PlayerList) {
        presenter.selectList(list: list)
        gamePresenter.restartGame()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView DataSource

extension ListBrowserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listCellIndetifier, for: indexPath)  as! ListBrowserTableViewCell
        let list = lists[indexPath.row]
        cell.setCellData(list: list)
        cell.delegate = self
        return cell
    }
}

// MARK: - TableView Delegate

extension ListBrowserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = lists[indexPath.row]
        self.performSegue(withIdentifier: Segues.detailListPlayers, sender: selectedList)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "DELETE_ACTION".localized(), handler: { [weak self] (_, indexPath) in
            if let strongSelf = self {
                strongSelf.presenter.deleteList(playersList: strongSelf.lists[indexPath.row], indexPath: indexPath)
            }
        })]
    }
}

// MARK: - TextField Delegate

extension ListBrowserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateAddButtonState(text: textField.text)
        return true
    }
}
