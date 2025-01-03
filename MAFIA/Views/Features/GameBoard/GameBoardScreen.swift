import SwiftUI

extension GameBoardScreen {
    enum Route {
        case playerList
    }
}

struct GameBoardScreen: View {
    @StateObject var viewModel: GameBoardViewModel = .init()

    @State private var path: [Route] = []
    @State private var playerToAdd: String = ""

    var body: some View {
        NavigationStack(path: self.$path) {
            Group {
                switch viewModel.state {
                case .empty:
                    self.emptyView
                case .playing(let players):
                    self.playingView(players: players)
                        .padding(.top, .spacing.large)
                        .toolbar {
                            ToolbarItemGroup {
                                Button(action: {
                                    self.viewModel.presentedSheet = .addPlayer
                                }, label: {
                                    Image(icon: .plus)
                                })

                                Button(action: {                                    
                                    self.viewModel.presenter.restartGame()
                                }, label: {
                                    Image(icon: .refresh)
                                })
                            }
                        }
                        .tint(Utils.Palette.Basic.black.color)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .playerList: Text("Player List goes here")
                }
            }
            .navigationTitle("MAFIA")
            .navigationBarTitleDisplayMode(.inline)

        }
        .alert(item: self.$viewModel.presentedAlert) { alert in
            switch alert {
            case .gameOver(let winner):
                var message: String = ""
                switch winner {
                case .villager, .king, .doctor, .sheriff:
                    message = "CIVILIANS_WON_GAME_MESSAGE".localized()
                case .mob, .none:
                    message = "MAFIA_WON_GAME_MESSAGE".localized()
                }
                return Alert(
                    title: Text("END_GAME_TITLE".localized()).title(),
                    message: Text(message).body(),
                    primaryButton: .default(
                        Text("END_GAME_ACTION_TITLE".localized())) {
                            self.viewModel.presenter.restartGame()
                    },
                    secondaryButton: .cancel(Text("CONTINUE_GAME_ACTION_TITLE".localized()))
                )
            case .custom(let title, let message, _, let action):
                return Alert(
                    title: Text(title ?? "").title(),
                    message: Text(message ?? "").body(),
                    dismissButton: .default(Text("OK".localized()), action: {
                        action?()
                        self.viewModel.presentedAlert = nil
                    })
                )
            }
        }
        .sheet(item: self.$viewModel.presentedSheet) { sheet in
            switch sheet {
            case .addPlayer:
                AddPlayerView(addPlayerAction: { name in
                    self.viewModel.presentedSheet = nil
                    self.viewModel.presenter.addPlayerInCurrentGame(withName: name)
                })
                .presentationDetents([.fraction(0.3)])
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: .spacing.medium) {
            Text("LIST_PLAYER_NO_NAME".localized())
                .title()
                .multilineTextAlignment(.center)

            Text("MAFIA_PHRASE_1".localized())
                .subtitle()

            Button(action: {
                self.path.append(.playerList)
            }, label: {
                Text("SELECT_NEW_LIST_TO_PLAY".localized())
                        .primaryButton()
            })
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    private func playingView(players: [Player]) -> some View {
        VStack {
            self.playingHeader

            SwiftUI.List {
                ForEach(players, id: \.name) { player in
                    let isPlayerDead = self.viewModel.isPlayerDead(player)
                    HStack {

                        Text(player.name)
                            .body()
                            .bold()

                        Spacer()

                        VStack(spacing: .spacing.small) {

                            Image(icon: player.role.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: .iconSize.medium, height: .iconSize.medium)
                                .opacity(isPlayerDead ? 0.2 : 1)
                            Text(player.role.roleDescription)
                                .body()

                        }
                    }
                    .foregroundColor(isPlayerDead ? Utils.Palette.Basic.veryLightGrey.color : Utils.Palette.Basic.black.color)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        if isPlayerDead {
                            Button {
                                self.viewModel.presenter.revivePlayer(player: player)
                            } label: {
                                Text("REVIVE_PLAYER_BUTTON_TITLE".localized())
                            }
                            .tint(.green)
                        } else {
                            Button {
                                self.viewModel.presenter.kill(player: player)
                            } label: {
                                Text("KILL_PLAYER_BUTTON_TITLE".localized())
                            }
                            .tint(.red)
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            self.viewModel.presenter.deletePlayer(player: player, indexPath: IndexPath())
                        } label: {
                            Text("DELETE_ACTION".localized())
                        }
                        .tint(.red)
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    private var playingHeader: some View {
        VStack(spacing: .zero) {

            HStack {
                Text(Image(icon: .dotScope))
                    .subtitle()

                Text(self.viewModel.selectedListName)
                    .subtitle()
            }

            HStack(alignment: .top, spacing: .spacing.large) {

                self.playingRoleView(
                    icon: .villager,
                    aliveCount: self.viewModel.aliveCiviliansPlayerText
                )

                Text(viewModel.totalNumberOfPlayers)
                    .body()

                self.playingRoleView(
                    icon: .mob,
                    aliveCount: self.viewModel.aliveMafiaPlayerText
                )
            }
            .padding(.top, .spacing.medium)
            .multilineTextAlignment(.center)
            .overlay(alignment: .top) {
                Divider()
                    .frame(height: .borderWidth.medium)
                    .background(Utils.Palette.Basic.red.color)
            }
        }
    }

    private func playingRoleView(icon: Icon, aliveCount: String) -> some View {
        VStack(spacing: .spacing.small) {
            Image(icon: icon)

            Text(aliveCount)
                .body()
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    GameManager.currentGame.setSelectedList(listPlayers: RawList(name: "Lista de prueba", players: [
        Player(name: "Jugador 1"),
        Player(name: "Jugador 2"),
        Player(name: "Jugador 3"),
        Player(name: "Jugador 4"),
        Player(name: "Jugador 5"),
        Player(name: "Jugador 7"),
        Player(name: "Jugador 9")
    ]))
    return GameBoardScreen()
}

extension Role {
    var icon: Icon {
        switch self {
        case .villager: return .villager
        case .mob: return .mob
        case .king: return .king
        case .doctor: return .doctor
        case .sheriff: return .sheriff
        case .none: return .none
        }
    }
}
