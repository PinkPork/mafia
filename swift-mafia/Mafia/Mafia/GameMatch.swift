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
        let mobstersAlive = match.players
            .filter {
                $0.role == .mobster
                && $0.state == .alive
            }
            .count
        let nonMobsterAlive = match.players
            .filter {
                $0.role != .mobster
                && $0.state == .alive
            }
            .count

        if mobstersAlive == 0 {
            match.state = .over(withWinner: .villagers)
        } else if nonMobsterAlive <= match.players.count / 3 {
            match.state = .over(withWinner: .mobsters)
        } else {
            match.state = match.state == .day ? .night : .day
        }

        $game.withLock {
            $0.matches[id: match.id] = match
            $0 = $0
        }
    }
}

struct GameMatchView: View {
    @State var model: GameMatchModel

    init?(id: Game.ID, matchId: Match.ID? = nil) {
        @Shared(.games) var games
        guard let game = Shared($games[id: id])
        else { return nil }
        _model = State(wrappedValue: GameMatchModel(game: game, matchId: matchId))
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

                        Text(" - ")
                        Text(player.player.name)
                        Spacer()
                        Image(
                            systemName: player.state == .alive
                            ? "person.fill"
                            : "person.slash"
                        )
                        .renderingMode(.template)
                        .foregroundColor(player.state == .alive ? .green : .red)
                    }
                    .if(model.match.state != .day) {
                        $0.swipeActions {
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
    @Shared(.games) var games = [
        game
    ]
    NavigationStack {
        GameMatchView(id: game.id)
    }
}
