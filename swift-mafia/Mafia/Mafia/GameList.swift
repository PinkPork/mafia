import Dependencies
import IdentifiedCollections
import Sharing
import SwiftUI
import SwiftUINavigation

@MainActor
@Observable
final class GameListModel {
    @ObservationIgnored @Dependency(\.uuid) var uuid

    var addGame: GameFormModel?
    @ObservationIgnored @Shared(.games) var games

    func addGameButtonTapped() {
        addGame = withDependencies(from: self) {
            GameFormModel(
                game: Game(id: Game.ID(uuid()))
            )
        }
    }

    func dismissAddGameButtonTapped() {
        addGame = nil
    }

    func confirmAddGameButtonTapped() {
        defer { addGame = nil }

        guard let addGame else { return }
        let game = addGame.game
        // TODO: Add rules to validate the game
        _ = $games.withLock { $0.append(game) }
    }
}

struct GameListView: View {
    @State var model = GameListModel()

    var body: some View {
        List {
            if let loadError = model.$games.loadError {
                ContentUnavailableView {
                    Label("Error loading games", systemImage: "exclamationmark.triangle.fill")
                } description: {
                    Text(loadError.localizedDescription)
                }
            } else if model.games.isEmpty {
                Label("No games available, start by creating one", systemImage: "gamecontroller")
            } else {
                ForEach(model.games) { game in
                    NavigationLink(value: AppPath.gameDetail(id: game.id)) {
                        CardView(game: game)
                    }
                }
            }
        }
        .toolbar {
            Button("Add Game") {
                model.addGameButtonTapped()
            }
        }
        .navigationTitle("Mafia Games")
        .sheet(item: $model.addGame) { gameFormModel in
            NavigationStack {
                GameFormView(model: gameFormModel)
                    .navigationTitle("New Game")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                model.dismissAddGameButtonTapped()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                model.confirmAddGameButtonTapped()
                            }
                        }
                    }
            }
        }
    }
}

struct CardView: View {
    let game: Game
    var body: some View {
        VStack(spacing: 16) {
            Text(game.title)
                .font(.headline)
            Label("\(game.players.count)", systemImage: "person.3")
                .font(.caption)
        }
        .padding(.vertical, 8)
    }
}

extension SharedReaderKey where Self == FileStorageKey<IdentifiedArrayOf<Game>>.Default {
    static var games: Self {
        Self[
            .fileStorage(
                dump(URL.documentsDirectory.appending(component: "games.json"))
            ),
            default: [
                .mock
            ]
        ]
    }
}

#Preview {
    @Shared(.games) var games = [
        .mock
    ]
    NavigationStack {
        GameListView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
