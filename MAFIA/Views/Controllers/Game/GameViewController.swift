//
//  GameViewController.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/18/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var villagerLabel: UILabel!
    @IBOutlet weak var mobLabel: UILabel!
    @IBOutlet weak var currentPlayerListName: UILabel!
    
    
    // MARK: Vars & Constants
    
    private let kHeaderView: CGFloat = 80
    private var presenter: GamePresenter!
    private var playersToDisplay: [PlayerMO] = [PlayerMO]() {
        didSet {
            tableView.isUserInteractionEnabled = playersToDisplay.count >= GameRules.minimumPlayers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupTableView()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
    
    // MARK: - IBActions
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        if let menu = SideMenu.sharedInstance {
            try! menu.show(view: self.view)
            menu.menuViewController?.delegate = self
        }
    }
    
    
    @IBAction func refreshRoles(_ sender: UIBarButtonItem) {
        refreshRoles()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = GamePresenter(view: self)
        presenter.showPlayers()
        currentPlayerListName.text = "LIST_PLAYER_NO_NAME".localized()
        villagerLabel.text = nil
        mobLabel.text = nil
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: kHeaderView, left: 0, bottom: 0, right: 0)
        tableView.register(UINib.init(nibName: PlayerTableViewCell.nib, bundle: Bundle.main), forCellReuseIdentifier: PlayerTableViewCell.identifier)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ListPlayersViewController {
            destinationViewController.gamePresenter = presenter
        }
     }
    
    
}

// MARK: - PlayerView Protocol

extension GameViewController: GameView {
    
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
    
    func updateGameUI() {
        villagerLabel.text = presenter.aliveCiviliansPlayerText
        mobLabel.text = presenter.aliveMafiaPlayerText
        currentPlayerListName.text = presenter.selectedListName
    }
    
    func endGame(winner: Role) {
        var message: String = ""
        switch winner {
        case .villager:
            message = "CIVILIANS_WON_GAME_MESSAGE".localized()
        case .mob:
            message = "MAFIA_WON_GAME_MESSAGE".localized()
        default:
            return
        }
        
        let alert = UIAlertController(title: "END_GAME_TITLE".localized(), message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "END_GAME_ACTION_TITLE".localized(), style: .default) { [weak self] (_) in
            if let strongSelf = self {
                strongSelf.presenter.restartGame()
            }
        }
        let continuePlayingAction = UIAlertAction(title: "CONTINUE_GAME_ACTION_TITLE".localized(), style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(continuePlayingAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func restartGame() {
        presenter.showPlayers()
        refreshRoles()
    }
    
    private func refreshRoles() {
        playersToDisplay = presenter.refreshRoles(players: playersToDisplay)
        tableView.reloadData()
    }
}


// MARK: - TableView Datasource

extension GameViewController: UITableViewDataSource {
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

extension GameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerToEliminate = playersToDisplay[indexPath.row]
        presenter.kill(player: playerToEliminate)
        presenter.didEndGame()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedPlayer = playersToDisplay[indexPath.row]
        presenter.revivePlayer(player: deselectedPlayer)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: .destructive, title: "DELETE_PLAYER_ACTION".localized(), handler: { [weak self] (_, indexPath) in
            if let strongSelf = self {
                strongSelf.presenter.deletePlayer(player: strongSelf.playersToDisplay[indexPath.row], indexPath: indexPath)
            }
        })]
    }
}

extension GameViewController: MenuViewControllerDelegate {
    func performSegue(withIdentifier identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
}
