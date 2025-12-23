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
import IdentifiedCollections

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
    @State var player: Match.RolePlayer?
    @State var model: GameMatchModel
    @State var roleReveal: Bool

    init?(id: Game.ID, matchId: Match.ID? = nil, roleReveal: Bool = false) {
        @Shared(.games) var games
        guard let game = Shared($games[id: id])
        else { return nil }
        _model = State(wrappedValue: GameMatchModel(game: game, matchId: matchId))
        _roleReveal = State(initialValue: roleReveal)
    }

    var body: some View {        
        List {
            if case let .over(winner) = model.match.state {
                Text("Game Over")
                Text("Winner: \(winner.localizedStringResource)")
            } else {
                Section {
                    Label(
                        model.match.state == .day ? "Day" : "Night",
                        systemImage: model.match.state == .day ? "sun.max.fill" : "moon.fill"
                    )
                    Button("Next Turn") {
                        model.nextTurnButtonTapped()
                    }
                    if model.match.state == .day {
                        HStack {
                            Spacer()
                            StopWatchContentView()
                            Spacer()
                        }
                    }
                } header: {
                    Text("Current Turn")
                }
            }

            Section {
                HStack {
                    StatView(
                        icon: Role.mobster.systemImage,
                        color: .red,
                        title: "Mobsters",
                        value: "\(model.match.players.filter { $0.role == .mobster && $0.state == .alive }.count)"
                    )

                    Spacer()

                    StatView(
                        icon: "person.3.fill",
                        color: .green,
                        title: "Villagers",
                        value: "\(model.match.players.filter { $0.role != .mobster && $0.state == .alive }.count)"
                    )

                    Spacer()

                    StatView(
                        icon: "heart.fill",
                        color: .blue,
                        title: "Alive",
                        value: String(format: "%1$d / %2$d", model.match.players.filter { $0.state == .alive }.count, model.match.players.count)
                    )
                }
            } header: {
                Text("Summary")
            }

            Section {
                ForEach(model.match.players.sorted(by: { $0.role > $1.role })) { player in
                    RolePlayerView(
                        player: player
                    )
                    .onTapGesture {
                        self.player = player
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
        .overlay {
            if roleReveal {
                RoleRevealView(players: model.match.players, isPresented: $roleReveal)
                    .background(Color.white)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Start Game") {
                                roleReveal.toggle()
                            }
                        }
                    }
            }
        }
        .sheet(item: $player) { player in
            SelectedRolePlayerView(player: player)
        }
        .navigationTitle(model.game.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatView: View {
    let icon: String
    let color: Color
    let title: LocalizedStringResource
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .padding()
                .background(color.opacity(0.2))
                .clipShape(Circle())

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}

struct SelectedRolePlayerView: View {
    let player: Match.RolePlayer

    var body: some View {
        VStack {
            Image(systemName: player.role.systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()

            Text(player.player.name)
                .font(.title)
            Text(player.role.localized)
                .font(.largeTitle)
        }
    }
}

struct RolePlayerView: View {
    let player: Match.RolePlayer

    var body: some View {
        HStack {
            Label(player.role.localized, systemImage: player.role.systemImage)
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
        .opacity(player.state == .alive ? 1 : 0.3)
        .contentShape(Rectangle())
    }
}

private struct RoleRevealView: View {
    let players: IdentifiedArrayOf<Match.RolePlayer>
    @Binding var isPresented: Bool
    @State private var dragOffset: CGFloat = 0
    @State private var index: Int = 0
    @State private var revealed: Bool = false
    @State private var roleViewHeight: CGFloat = .zero
    @State private var playerCardHeight: CGFloat = .zero
    private var currentPlayer: Match.RolePlayer? {
        return players.indices.contains(index) ? players[index] : nil
    }
    
    private var hasNextPlayer: Bool {
        index < players.count - 1
    }

    var body: some View {
        VStack {
            if let player = currentPlayer {
                Spacer()

                ZStack {
                    VStack(spacing: 12) {
                        Image(systemName: player.role.systemImage)
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text(player.role.localized)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .onGeometryChange(for: CGRect.self) { proxy in
                        proxy.frame(in: .local)
                    } action: {
                        roleViewHeight = $0.size.height
                    }


                    // Draggable card on top
                    PlayerCardView(name: player.player.name)
                        .padding(.horizontal)
                        .onGeometryChange(for: CGRect.self) {
                            $0.frame(in: .local)
                        } action: {
                            playerCardHeight = $0.height
                        }
                        .offset(y: dragOffset)
                        .gesture(
                            DragGesture(minimumDistance: 5)
                                .onChanged { value in
                                    let dy = value.translation.height
                                    dragOffset = dy
                                }
                                .onEnded { _ in
                                    if abs(dragOffset) > (roleViewHeight + playerCardHeight / 4) {
                                        revealed = true
                                    }
                                    dragOffset = 0
                                }
                        )
                        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: dragOffset)
                }
            }

            Spacer(minLength: 0)

            Button {
                if hasNextPlayer {
                    index += 1
                    revealed = false
                } else {
                    isPresented = false
                }
            } label: {
                Text(hasNextPlayer ? "Next Player" : "Start Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Capsule().fill(Color.accentColor))
                    .foregroundColor(.white)
            }
            .opacity(revealed ? 1 : 0)
            .animation(.default, value: revealed)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private struct PlayerCardView: View {
        let name: String

        var body: some View {
            VStack(spacing: 16) {
                Text(name)
                    .font(.title)
                    .fontWeight(.semibold)

                VStack(spacing: 8) {
                    Image(systemName: "hand.draw")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    Text("Drag up to reveal the role")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(50)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThickMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(.quaternary, lineWidth: 1)
            )
            .shadow(radius: 8)
        }
    }
}

#Preview {
    var game = Game.mock
    @Shared(.games) var games = [
        game
    ]
    NavigationStack {
        GameMatchView(id: game.id, roleReveal: true)
    }
}

