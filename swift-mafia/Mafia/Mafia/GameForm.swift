//
//  GameFormView.swift
//  Mafia
//
//  Created by Jaime Andres Laino Guerra on 1/02/25.
//

import Dependencies
import SwiftUI
import SwiftUINavigation

@MainActor
@Observable
final class GameFormModel: Identifiable {
    enum Field: Hashable {
        case title
        case player(Player.ID)
    }

    @ObservationIgnored @Dependency(\.uuid) var uuid

    var focus: Field?
    var game: Game

    init(
        focus: Field? = .title,
        game: Game
    ) {
        self.focus = focus
        self.game = game
        shouldAddInitalPlayer()
    }

    func deleteAttendees(at indices: IndexSet) {
        game.players.remove(atOffsets: indices)
        shouldAddInitalPlayer()
        guard let firstIndex = indices.first
        else { return }
        let index = min(firstIndex, game.players.count - 1)
        focus = .player(game.players[index].id)
    }

    func addPlayerButtonTapped() {
        let player = Player(id: Player.ID(uuid()))
        game.players.append(player)
        focus = .player(player.id)
    }

    private func shouldAddInitalPlayer() {
        if game.players.isEmpty {
            game.players.append(Player(id: Player.ID(uuid())))
        }
    }
}

struct GameFormView: View {
    @FocusState var focus: GameFormModel.Field?
    @Bindable var model: GameFormModel

    var body: some View {
        Form {
            Section {
                TextField("New Game Title", text: $model.game.title)
                    .focused($focus, equals: .title)
            } header: {
                Text("Game Title")
            }

            Section {
                ForEach($model.game.players) { $player in
                    TextField("Player Name", text: $player.name)
                        .onSubmit {
                            model.addPlayerButtonTapped() 
                        }
                        .focused($focus, equals: .player(player.id))
                }
                .onDelete { indexSet in
                    model.deleteAttendees(at: indexSet)
                }

                Button("Add Player") {
                    model.addPlayerButtonTapped()
                }
            } header: {
                Text("Players")
            }
        }
        .bind($model.focus, to: $focus)
    }
}

#Preview {
    NavigationStack {
        GameFormView(model: GameFormModel(game: .mock))
    }
}
