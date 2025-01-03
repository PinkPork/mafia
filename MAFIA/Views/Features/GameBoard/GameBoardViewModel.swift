import Foundation
import UIKit

extension GameBoardViewModel {
    enum State: Equatable {
        case empty
        case playing(players: [Player])

        static func == (lhs: GameBoardViewModel.State, rhs: GameBoardViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.empty, .empty):
                return true
            case (.playing(let lhsPlayers), .playing(let rhsPlayers)):
                return lhsPlayers == rhsPlayers
            case (.empty, _), (.playing, _):
                return false
            }
        }
    }

    enum PresentedAlert: Identifiable {
        var id: UUID { UUID() }

        case gameOver(winner: Role)
        case custom(title: String?, message: String?, preferredStyle: UIAlertController.Style, completionFirstAction: (() -> Void)?)
    }

    enum PresentedSheet: Identifiable {
        var id: UUID { UUID() }

        case addPlayer
    }
}

final class GameBoardViewModel: ObservableObject {
    private(set) lazy var presenter: GamePresenter = .init(view: self)

    @Published var state: State = .empty
    @Published var presentedAlert: PresentedAlert?
    @Published var presentedSheet: PresentedSheet?

    var aliveCiviliansPlayerText: String {
        return self.presenter.aliveCiviliansPlayerText ?? ""
    }

    var aliveMafiaPlayerText: String {
        return self.presenter.aliveMafiaPlayerText ?? ""
    }

    var totalNumberOfPlayers: String {
        return self.presenter.totalNumberOfPlayers ?? ""
    }

    var selectedListName: String {
        return self.presenter.selectedListName ?? ""
    }

    init() {        
        self.presenter.showPlayers()
    }

    func isPlayerDead(_ player: Player) -> Bool {
        return GameManager.currentGame.checkForKilledPlayers(player: player)
    }
}

extension GameBoardViewModel: GameView {
    func setPlayers(players: [Player]) {
        self.state = .playing(players: players)
    }

    func addNewPlayer(player: Player) {
        guard case var .playing(players) = self.state else {
            return
        }

        players.append(player)
        self.state = .playing(players: presenter.refreshRoles(players: players))
    }

    func deletePlayer(player: Player, indexPath: IndexPath) {
        guard case var .playing(players) = self.state else {
            return
        }

        guard let index = players.firstIndex(of: player) else {
            return
        }
        players.remove(at: index)
        self.state = .playing(players: presenter.refreshRoles(players: players))
    }

    func updateGameUI() {
        self.state = .playing(players: GameManager.currentGame.playersPlaying ?? [])
    }

    func endGame(winner: Role) {
        self.presentedAlert = .gameOver(winner: winner)
    }

    func restartGame() {
        self.presenter.showPlayers()
    }

    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style, completionFirstAction: (() -> Void)?) {
        self.presentedAlert = .custom(title: title, message: message, preferredStyle: preferredStyle, completionFirstAction: completionFirstAction)
    }
}
