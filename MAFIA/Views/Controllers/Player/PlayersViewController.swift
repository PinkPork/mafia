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
    @IBOutlet weak var civiliansLabel: UILabel!
    @IBOutlet weak var mafiaLabel: UILabel!
    
    
    // MARK: Vars & Constants
    
    private let kHeaderView: CGFloat = 60
    var presenter: PlayerPresenter!
    var playersToDisplay: [PlayerMO] = [PlayerMO]() {
        didSet {
            updateGameUI()
        }
    }
    var eliminatedPlayers: [PlayerMO] = [PlayerMO]() {
        didSet {
            updateGameUI()
        }
    }
    
    var civilianTotal: Int {
        get {
            let mafiaPlayers = playersToDisplay.count / 3
            var civiliansPlaying = playersToDisplay.count - mafiaPlayers
            civiliansPlaying = eliminatedPlayers.reduce(civiliansPlaying, {(result, player) -> Int in
                return player.role != .mafia ? result - 1 : result
            })
            
            return civiliansPlaying
        }
    }
    
    var mafiaTotal: Int {
        get {
            var mafiaPlayers = playersToDisplay.count / 3
            mafiaPlayers = eliminatedPlayers.reduce(mafiaPlayers, {(result, player) -> Int in
                return player.role == .mafia ? result - 1 : result
            })
            return mafiaPlayers
        }
    }
    
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
        tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: kHeaderView, left: 0, bottom: 0, right: 0)
        tableView.register(UINib.init(nibName: PlayerTableViewCell.nib, bundle: Bundle.main), forCellReuseIdentifier: PlayerTableViewCell.identifier)
    }
    
    // MARK: - PlayerView Protocol
    
    func setPlayers(players: [PlayerMO]) {
        playersToDisplay = players
        tableView.reloadData()
    }
    
    func addNewPlayer(player: PlayerMO) {
        playersToDisplay.append(player)
        playersToDisplay = self.presenter.refreshRoles(players: playersToDisplay)
        tableView.reloadData()
    }
    
    func deletePlayer(player: PlayerMO, indexPath: IndexPath) {
        playersToDisplay.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func addPlayer(_ sender: UIBarButtonItem) {
        //        let alert = UIAlertController(title: "New Player",
        //                                      message: "Add a new player",
        //                                      preferredStyle: .alert)
        //
        //        let saveAction = UIAlertAction(title: "Save",
        //                                       style: .default) {
        //                                        [unowned self] action in
        //
        //                                        guard let textField = alert.textFields?.first,
        //                                            let nameToSave = textField.text else {
        //                                                return
        //                                        }
        //
        //                                        self.presenter.savePlayer(name: nameToSave)
        //        }
        //
        //        let cancelAction = UIAlertAction(title: "Cancel",
        //                                         style: .default)
        //
        //        alert.addTextField()
        //
        //        alert.addAction(saveAction)
        //        alert.addAction(cancelAction)
        //
        //        present(alert, animated: true)
        try! SideMenu.sharedInstance?.show(view: self.view)
    }
    
    
    @IBAction func refreshRoles(_ sender: UIBarButtonItem) {
        playersToDisplay = self.presenter.refreshRoles(players: playersToDisplay)
        eliminatedPlayers.removeAll()
        tableView.reloadData()
    }
    
    // MARK: - Methods
    
    func updateGameUI() {
        civiliansLabel.text = "\("CIVILIANS_TITLE".localized()) \n \(civilianTotal)"
        mafiaLabel.text = "\("MAFIA_TITLE".localized()) \n \(mafiaTotal)"
        endGame()
    }
    
    func endGame() {
        
        if playersToDisplay.count < GameRules.minimumPlayers {
            return
        }
        
        var message: String = ""
        
        if mafiaTotal == 0 {
            message = "CIVILIANS_WON_GAME_MESSAGE".localized()
        } else if civilianTotal > mafiaTotal {
            return
        } else if mafiaTotal >= civilianTotal {
            message = "MAFIA_WON_GAME_MESSAGE".localized()
        }
        let alert = UIAlertController(title: "END_GAME_TITLE".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "END_GAME_ACTION_TITLE".localized(), style: .default) { [weak self] (_) in
            if let strongSelf = self {
                strongSelf.playersToDisplay = strongSelf.presenter.refreshRoles(players: strongSelf.playersToDisplay)
                strongSelf.eliminatedPlayers.removeAll()
                strongSelf.tableView.reloadData()
            }
        }
        let continuePlayingAction = UIAlertAction(title: "CONTINUE_GAME_ACTION_TITLE".localized(), style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(continuePlayingAction)
        self.present(alert, animated: true, completion: nil)
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

// MARK: - TableView Delegate

extension PlayersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerToEliminate = playersToDisplay[indexPath.row]
        eliminatedPlayers.append(playerToEliminate)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedPlayer = playersToDisplay[indexPath.row]
        eliminatedPlayers.remove(at: eliminatedPlayers.index(of: deselectedPlayer)!)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: .destructive, title: "DELETE_PLAYER_ACTION".localized(), handler: { [weak self] (_, indexPath) in
            if let strongSelf = self {
                strongSelf.presenter.deletePlayer(player: strongSelf.playersToDisplay[indexPath.row], indexPath: indexPath)
            }
        })]
    }
}

