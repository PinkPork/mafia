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
    
    var listPlayers: [PlayersListMO] = [PlayersListMO]()
    var presenter: ListPlayersPresenter!

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
    
    func setupView() {
        presenter = ListPlayersPresenter(view: self, playerListService: PlayersListService())
        
        presenter.showListPlayers()
    }
    
    func setupTableView() {
        tableView.dataSource = self
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
