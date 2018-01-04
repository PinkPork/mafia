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
    }
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = ListPlayersPresenter(view: self)
        presenter.showListPlayers()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - ListPlayersView protocol conformance

extension ListPlayersViewController: ListPlayersView {
    func addNewList(listPlayer: PlayersListMO) {
        listPlayers.append(listPlayer)
        tableView.reloadData()
    }
    
    func setListPlayers(listPlayers: [PlayersListMO]) {
        self.listPlayers = listPlayers
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource

extension ListPlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let list = listPlayers[indexPath.row]
        cell.textLabel?.text = list.name
        return cell
    }
}

extension ListPlayersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = listPlayers[indexPath.row]
        presenter.selectList(list: selectedList)
        gamePresenter.restartGame()
    }
}
