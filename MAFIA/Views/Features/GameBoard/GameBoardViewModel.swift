import Foundation
import UIKit

extension GameBoardScreen.ViewModel {
    enum State: Equatable {
        case empty
        case playing(players: [Player])
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

extension GameBoardScreen {
    final class ViewModel: ObservableObject, Coordinator {
        private(set) lazy var presenter: GamePresenter = .init(view: self)

        @Published var state: State
        @Published var presentedAlert: PresentedAlert?
        @Published var presentedSheet: PresentedSheet?
        @Published var path: [GameBoardScreen.Route] = []

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

        init(state: State) {
            self.state = state
        }

        func isPlayerDead(_ player: Player) -> Bool {
            return GameManager.currentGame.checkForKilledPlayers(player: player)
        }
    }
}
extension GameBoardScreen.ViewModel: GameView {
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
        guard winner != .none else {
            return
        }
        self.presentedAlert = .gameOver(winner: winner)
    }

    func restartGame() {
        self.presenter.showPlayers()
    }

    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style, completionFirstAction: (() -> Void)?) {
        self.presentedAlert = .custom(title: title, message: message, preferredStyle: preferredStyle, completionFirstAction: completionFirstAction)
    }
}
