import IdentifiedCollections
import SwiftUI
import Tagged

struct Game: Hashable, Identifiable, Codable {
    let id: Tagged<Self, UUID>
    var title: String = ""
    var players: IdentifiedArrayOf<Player> = []
    var matches: IdentifiedArrayOf<Match> = []
}

struct Player: Hashable, Identifiable, Codable {
    let id: Tagged<Self, UUID>
    var name: String = ""
}

enum Role: Hashable, Codable {
    case king, doctor, sheriff, villager, mobster
}

enum RolePlayerState: Hashable, Codable {
    case alive, dead
}

enum MatchState: Hashable, Codable {
    case day, night, over
}

struct Match: Hashable, Identifiable, Codable {
    struct RolePlayer: Hashable, Identifiable, Codable {
        let id: Player.ID
        let player: Player
        let role: Role
        var state: RolePlayerState = .alive
    }

    let id: Tagged<Self, UUID>
    var players: IdentifiedArrayOf<RolePlayer> = []
    var state: MatchState = .day

    init(
        id: Tagged<Self, UUID>,
        players: IdentifiedArrayOf<Player>
    ) {
        self.id = id
        self.players = Self.assignRoles(players: players)
    }

    static func assignRoles(players: IdentifiedArrayOf<Player>) -> IdentifiedArrayOf<RolePlayer> {
        var players = players
        var numberOfMobsters = players.count / 3
        var uniqueRoles = [Role.king, .doctor, .sheriff]

        players.shuffle()

        let rolePlayers = players.map { player in
            if numberOfMobsters > 0 {
                numberOfMobsters -= 1
                return RolePlayer(
                    id: player.id,
                    player: player,
                    role: .mobster
                )
            }

            if let uniqueRole = uniqueRoles.popLast() {
                return RolePlayer(
                    id: player.id,
                    player: player,
                    role: uniqueRole
                )
            }

            return RolePlayer(
                id: player.id,
                player: player,
                role: .villager
            )
        }
        return IdentifiedArrayOf<RolePlayer>(uniqueElements: rolePlayers)
    }
}

extension Game {
    static let mock = Self(
        id: .init(rawValue: UUID()),
        title: "Mafia",
        players: [
            Player(id: .init(rawValue: UUID()), name: "Jaime"),
            Player(id: .init(rawValue: UUID()), name: "Santy"),
            Player(id: .init(rawValue: UUID()), name: "Hugo"),
            Player(id: .init(rawValue: UUID()), name: "Jose Calvo"),
            Player(id: .init(rawValue: UUID()), name: "Lucho"),
            Player(id: .init(rawValue: UUID()), name: "El de Alemania"),
        ]
    )
}
