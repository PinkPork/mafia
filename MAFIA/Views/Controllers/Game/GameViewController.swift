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
    private var playersToDisplay: [Player] = [Player]() {
        didSet {
            updateGameUI()
        }
    }
    private var pullToRefresh: UIRefreshControl!
    private var addPlayerAction: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupTableView()
        setupView()
        updateGameUI()
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
    
    @IBAction func addPlayerInCurrentGame(_ sender: Any) {
        
    }
    
    
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = GamePresenter(view: self)
        presenter.showPlayers()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: kHeaderView, left: 0, bottom: 0, right: 0)
        tableView.register(UINib.init(nibName: PlayerTableViewCell.nib, bundle: Bundle.main), forCellReuseIdentifier: PlayerTableViewCell.identifier)
        
        pullToRefresh = UIRefreshControl()
        pullToRefresh.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH_ACTION".localized())
        pullToRefresh.addTarget(self, action: #selector(refreshRoles(_:)), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullToRefresh
        } else {
            tableView.addSubview(pullToRefresh)
        }
    }
    
    private func refreshRoles() {
        playersToDisplay = presenter.refreshRoles(players: playersToDisplay)
        tableView.reloadData()
        self.pullToRefresh.endRefreshing()
    }
    
    @objc func refreshRoles(_ sender: UIBarButtonItem) {
        presenter.restartGame()
    }
    
    private func addPlayerPopUp() {
        let alertController = UIAlertController(title: "ADD_PLAYER_TITLE".localized(), message: "ADD_PLAYER_MESSAGE".localized(), preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.delegate = self as? UITextFieldDelegate
            textField.becomeFirstResponder()
        }
        
        addPlayerAction = UIAlertAction(title: "ADD_ACTION".localized(), style: .default) { (action) in
            let textField = alertController.textFields?.first
            guard let playerName = textField?.text, !playerName.isEmpty else { return }
            
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ListPlayersViewController {
            destinationViewController.gamePresenter = presenter
        } else if let destinationViewController = segue.destination as? PlayerDetailViewController {
            destinationViewController.navigationItem.title = presenter.selectedListName
            destinationViewController.player = sender as? Player
        }
    }
}

// MARK: - PlayerView Protocol

extension GameViewController: GameView {
    
    func setPlayers(players: [Player]) {
        playersToDisplay = players
        tableView.reloadData()
    }
    
    func addNewPlayer(player: Player) {
        playersToDisplay.append(player)
        playersToDisplay = self.presenter.refreshRoles(players: playersToDisplay)
        tableView.reloadData()
    }
    
    func deletePlayer(player: Player, indexPath: IndexPath) {
        playersToDisplay.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        refreshRoles()
    }
    
    func updateGameUI() {
        villagerLabel.text = presenter.aliveCiviliansPlayerText
        mobLabel.text = presenter.aliveMafiaPlayerText
        currentPlayerListName.text = presenter.selectedListName
        tableView.isUserInteractionEnabled = presenter.gameCanStart
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
        let displayedPlayer = playersToDisplay[indexPath.row]
        self.performSegue(withIdentifier: Segues.playerDetail, sender: displayedPlayer)
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let playerToKill = playersToDisplay[indexPath.row]
        var actionsForRow = [UITableViewRowAction]()
        if GameManager.currentGame.checkForKilledPlayers(player: playerToKill) == false {
            actionsForRow.append(UITableViewRowAction.init(style: .destructive, title: "KILL_PLAYER_BUTTON_TITLE".localized(), handler: { [weak self] (_, indexPath) in
                if let strongSelf = self {
                    strongSelf.presenter.kill(player: strongSelf.playersToDisplay[indexPath.row])
                    tableView.reloadData()
                }
            }))
        } else {
            actionsForRow.append(UITableViewRowAction.init(style: .normal, title: "REVIVE_PLAYER_BUTTON_TITLE".localized(), handler: { [weak self] (_, indexPath) in
                if let strongSelf = self {
                    strongSelf.presenter.revivePlayer(player: strongSelf.playersToDisplay[indexPath.row])
                    tableView.reloadData()
                }
            }))
        }
        actionsForRow.append(UITableViewRowAction.init(style: .destructive, title: "DELETE_ACTION".localized(), handler: { [weak self] (_, indexPath) in
            if let strongSelf = self {
                strongSelf.presenter.deletePlayer(player: playerToKill, indexPath: indexPath)
            }
        }))
        return actionsForRow
    }
}
extension GameViewController: MenuViewControllerDelegate {
    func performSegue(withIdentifier identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
}

