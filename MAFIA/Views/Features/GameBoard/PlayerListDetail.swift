import SwiftUI

extension PlayerListView {
    final class ViewModel: ObservableObject {
        enum State {
            case empty
            case list([Player])
        }

        enum Sheet: Identifiable {
            case addPlayer

            var id: UUID { UUID() }
        }

        @Published var state: State
        @Published var presentedSheet: Sheet?

        private(set) lazy var presenter: ListPresenter = .init(view: self)

        let list: PlayerList

        init(list: PlayerList) {
            self.list = list
            self.state = list.players.isEmpty ? .empty : .list(list.players)
        }
    }
}

extension PlayerListView.ViewModel: ListView {
    func addNewPlayer(player: Player) {
        self.list.players.append(player)
        print(self.list.players.map(\.name))
        self.state = .list(self.list.players)
    }

    func deletePlayer(player: Player, indexPath: IndexPath) {
        if let index = self.list.players.firstIndex(of: player) {
            self.list.players.remove(at: index)
        }
        if self.list.players.isEmpty {
            self.state = .empty
        } else {
            self.state = .list(self.list.players)
        }
    }

    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style, completionFirstAction: (() -> Void)?) {

    }

}

struct PlayerListView: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Group {
            switch self.viewModel.state {
            case .empty:
                Text("EMPTY_DETAIL_LIST_PLAYERS".localized())
                    .title()
                    .multilineTextAlignment(.center)
            case .list(let players):
                List {
                    ForEach(players, id: \.name) { player in
                        Text(player.name)
                            .body()
                            .swipeActions {
                                Button(role: .destructive, action: {
                                    self.viewModel.presenter.deletePlayer(player: player, list: self.viewModel.list, indexPath: IndexPath())
                                }, label: {
                                    Label("Delete", systemImage: "trash")
                                })
                            }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    self.viewModel.presentedSheet = .addPlayer
                }, label: {
                    Image(icon: .plus)
                })
            }
        }
        .sheet(item: self.$viewModel.presentedSheet) { sheet in
            switch sheet {
            case .addPlayer:
                TextInputView(title: "ADD_NEW_PLAYER".localized(), placeholder: "Jugador 1") { name in
                    self.viewModel.presenter.addPlayer(withName: name, toList: self.viewModel.list)
                    self.viewModel.presentedSheet = nil
                }
            }
        }
    }
}

#Preview("Populated") {
    NavigationStack {
        let viewModel = PlayerListView.ViewModel(list: PlayerList(name: "List 1", players: [Player(name: "Player 1"), Player(name: "Player 2")]))
        PlayerListView(viewModel: viewModel)
    }
}

#Preview("Empty") {
    NavigationStack {
        PlayerListView(viewModel: .init(list: PlayerList(name: "List 1", players: [])))
    }
}
