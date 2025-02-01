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
    @ObservationIgnored

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

    func toogleStateButtonTapped() {

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
            Button("Toogle State") {
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
