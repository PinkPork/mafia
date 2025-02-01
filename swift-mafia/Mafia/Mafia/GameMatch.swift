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
    @ObservationIgnored @Shared var game: Game

    init(game: Shared<Game>) {
        self._game = game
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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let game = Game.mock
    @Shared(.games) var games = [game]
    NavigationStack {
        GameMatchView(id: game.id)
    }
}
