//
//  PlayersViewController.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/18/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController, PlayerView {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Vars & Constants
    
    var presenter: PlayerPresenter!
    var playersToDisplay: [PlayerMO] = [PlayerMO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.presenter = PlayerPresenter(view: self, playerService: PlayerService())
        self.presenter.showPlayers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: PlayerTableViewCell.nib, bundle: Bundle.main), forCellReuseIdentifier: PlayerTableViewCell.identifier)
    }
    
    func setPlayers(players: [PlayerMO]) {
        playersToDisplay = players
        tableView.reloadData()
    }
    
    func addNewPlayer(player: PlayerMO) {
        playersToDisplay.append(player)
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func addPlayer(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Player",
                                      message: "Add a new player",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.presenter.savePlayer(name: nameToSave)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}


// MARK: - TableView Datasource
extension PlayersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as! PlayerTableViewCell
        let player = playersToDisplay[indexPath.row]
        cell.setCellData(player: player)
        return cell
    }
}

