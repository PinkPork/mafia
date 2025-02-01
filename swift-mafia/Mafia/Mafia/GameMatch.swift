//
//  GameMatch.swift
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
final class GameMatchModel {

    var match: Match
    @ObservationIgnored @Shared var game: Game

    init(game: Shared<Game>, matchId: Match.ID? = nil) {
        @Dependency(\.uuid) var uuid
        let match: Match = matchId.flatMap { game.matches[id: $0].wrappedValue } ?? Match(
            id: .init(uuid()),
            players: Match.assignRoles(players: game.wrappedValue.players)
        )

        self._game = game
        self.match = match
    }

    func nextTurnButtonTapped() {
        switch match.state {
        case .day:
            match.state = .night
        case .night:
            // TODO: validate players updates
            match.state = .over(withWinner: .mobsters)
            match.state = .day
        case .over: break
        }
    }
}

struct GameMatchView: View {
    @State var model: GameMatchModel

    init?(id: Game.ID) {
        @Shared(.games) var games
        guard let game = Shared($games[id: id])
        else { return nil }
        _model = State(wrappedValue: GameMatchModel(game: game))
    }

    var body: some View {
        List {
            if case let .over(winner) = model.match.state {
                Text("Game Over")
                Text("Winner: \(winner)")
            } else {
                Section {
                    Label(
                        model.match.state == .day ? "Day" : "Night",
                        systemImage: model.match.state == .day ? "sun.max.fill" : "moon.fill"
                    )
                    Button("Next Turn") {
                        model.nextTurnButtonTapped()
                    }
                } header: {
                    Text("Current Turn")
                }
            }

            Section {
                ForEach(model.match.players) { player in
                    HStack {
                        Label(player.player.name, systemImage: "person")

                        switch player.role {
                        case .mobster:
                            Label("Mobster", systemImage: "bandage")
                        case .villager:
                            Label("Villager", systemImage: "heart")
                        case .king:
                            Label("King", systemImage: "crown")
                        case .doctor:
                            Label("Doctor", systemImage: "cross")
                        case .sheriff:
                            Label("Sheriff", systemImage: "star")
                        }

                        Text(player.state == .alive ? "Alive" : "Dead")
                    }
                    .swipeActions {
                        Button("Kill") {
                            model.match.players[id: player.id]?.state = .dead
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading) {
                        Button("Revive") {
                            model.match.players[id: player.id]?.state = .alive
                        }
                        .tint(.green)
                    }
                }
            } header: {
                Text("Players")
            }

        }
        .navigationTitle(model.game.title)
    }
}

#Preview {
    var game = Game.mock
    @Shared(.games) var games = [game]
    NavigationStack {
        GameMatchView(id: game.id)
    }
}
