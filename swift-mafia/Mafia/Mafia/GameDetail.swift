//
//  GameDetail.swift
//  Mafia
//
//  Created by Jaime Andres Laino Guerra on 1/02/25.
//

import Dependencies
import Sharing
import SwiftUI
import SwiftUINavigation

@MainActor
@Observable
final class GameDetailModel {
    @ObservationIgnored @Dependency(\.continuousClock) var clock
    @ObservationIgnored @Dependency(\.uuid) var uuid

    var editGame: GameFormModel?
    @ObservationIgnored @Shared(.path) var path
    @ObservationIgnored @Shared var game: Game

    init(game: Shared<Game>) {
        self._game = game
    }

    func editButtonTapped() {
        editGame = withDependencies(from: self) {
            GameFormModel(game: game)
        }
    }

    func cancelEditButtonTapped() {
        editGame = nil
    }

    func doneEditingButtonTapped() {
        guard let editGame else { return }
        $game.withLock { $0 = editGame.game }
        self.editGame = nil
    }

    func startGameButtonTapped() {
        $path.withLock { $0.append(.game(id: game.id)) }
    }

    func deleteButtonTapped() async {
        _ = $path.withLock { $0.removeLast() }
        try? await clock.sleep(for: .seconds(0.4))
        @Shared(.games) var games
        withAnimation {
            _ = $games.withLock { $0.remove(id: game.id) }
        }
    }
}

struct GameDetailView: View {
    @State var model: GameDetailModel

    init?(id: Game.ID) {
        @Shared(.games) var games
        guard let game = Shared($games[id: id])
        else { return nil }
        _model = State(wrappedValue: GameDetailModel(game: game))
    }

    var body: some View {
        List {
            if model.game.players.count < 6 {
                Section {
                    Label("You need a minimum of 6 players to start", systemImage: "exclamationmark.triangle")
                        .accentColor(.red)
                }
            } else {
                Section {
                    Button {
                        model.startGameButtonTapped()
                    } label: {
                        Label("Start Game", systemImage: "play.fill")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                }
            }

            Section {
                ForEach(model.game.players) { player in
                    Label(player.name, systemImage: "person")
                }
            } header: {
                Text("Players")
            }

            Section {
                Button("Delete") {
                    Task { await model.deleteButtonTapped() }
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(model.game.title)
        .toolbar {
            Button("Edit") {
                model.editButtonTapped()
            }
        }
        .sheet(item: $model.editGame) { editModel in
            NavigationStack {
                GameFormView(model: editModel)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                model.cancelEditButtonTapped()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                model.doneEditingButtonTapped()
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    let game = Game.mock
    @Shared(.games) var games = [game]
    NavigationStack {
        GameDetailView(id: game.id)
    }
}
