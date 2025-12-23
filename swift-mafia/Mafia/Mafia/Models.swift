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

    var localized: LocalizedStringKey {
        switch self {
        case .king: return "King"
        case .doctor: return "Doctor"
        case .sheriff: return "Sheriff"
        case .villager: return "Villager"
        case .mobster: return "Mobster"
        }
    }

    var systemImage: String {
        switch self {
        case .mobster: return "bandage"
        case .villager: return "heart"
        case .king: return "crown"
        case .doctor: return "cross"
        case .sheriff: return "star"
        }
    }
}

enum RolePlayerState: Hashable, Codable {
    case alive, dead
}

enum MatchState: Hashable, Codable, Equatable, CustomLocalizedStringResourceConvertible {
    enum Winner: Hashable, Codable, Equatable, CustomLocalizedStringResourceConvertible {
        case mobsters, villagers

        var localizedStringResource: LocalizedStringResource {
            switch self {
            case .mobsters:
                "mobsters"
            case .villagers:
                "villagers"
            }
        }
    }

    case day, night, over(withWinner: Winner)

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .day:
            "Day"
        case .night:
            "Night"
        case .over(let winner):
            "Game over: \(winner.localizedStringResource.localizedStringResource)"
        }
    }
}

struct Match: Hashable, Identifiable, Codable {
    struct RolePlayer: Hashable, Identifiable, Codable {
        var id: Player.ID { player.id }
        let player: Player
        let role: Role
        var state: RolePlayerState = .alive
    }

    let id: Tagged<Self, UUID>
    var players: IdentifiedArrayOf<RolePlayer> = []
    var state: MatchState

    init(
        id: Tagged<Self, UUID>,
        state: MatchState = .day,
        players: IdentifiedArrayOf<RolePlayer>
    ) {
        self.id = id
        self.state = state
        self.players = players
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
                    player: player,
                    role: .mobster
                )
            }

            if let uniqueRole = uniqueRoles.popLast() {
                return RolePlayer(
                    player: player,
                    role: uniqueRole
                )
            }

            return RolePlayer(
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
            .Jaime,
            .Santy,
            .Hugo,
            .Calvo,
            .Lucho,
            .Alemania,
        ],
        matches: [
            .init(
                id: .init(rawValue: UUID()),
                state: .day,
                players: [
                    Match.RolePlayer(player: .Jaime, role: .king, state: .alive),
                    Match.RolePlayer(player: .Santy, role: .doctor, state: .alive),
                    Match.RolePlayer(player: .Hugo, role: .sheriff, state: .alive),
                    Match.RolePlayer(player: .Calvo, role: .mobster, state: .alive),
                    Match.RolePlayer(player: .Lucho, role: .mobster, state: .alive),
                    Match.RolePlayer(player: .Alemania, role: .mobster, state: .alive),
                ]
            ),
            .init(
                id: .init(rawValue: UUID()),
                state: .over(withWinner: .mobsters),
                players: [
                    Match.RolePlayer(player: .Jaime, role: .king, state: .dead),
                    Match.RolePlayer(player: .Santy, role: .doctor, state: .dead),
                    Match.RolePlayer(player: .Hugo, role: .sheriff, state: .alive),
                    Match.RolePlayer(player: .Calvo, role: .mobster, state: .alive),
                    Match.RolePlayer(player: .Lucho, role: .mobster, state: .alive),
                    Match.RolePlayer(player: .Alemania, role: .mobster, state: .alive),
                ]
            ),
        ]
    )
}

extension Player {

    static let Jaime = Player(id: .init(rawValue: UUID()), name: "Jaime")
    static let Santy = Player(id: .init(rawValue: UUID()), name: "Santy")
    static let Hugo = Player(id: .init(rawValue: UUID()), name: "Hugo")
    static let Calvo = Player(id: .init(rawValue: UUID()), name: "Jose Calvo")
    static let Lucho = Player(id: .init(rawValue: UUID()), name: "Lucho")
    static let Alemania = Player(id: .init(rawValue: UUID()), name: "El de Alemania")
}
