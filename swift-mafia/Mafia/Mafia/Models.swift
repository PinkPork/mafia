import IdentifiedCollections
import SwiftUI
import Tagged

struct Game: Hashable, Identifiable, Codable {
    let id: Tagged<Self, UUID>
    var title: String = ""
    var players: IdentifiedArrayOf<Player> = []
}

struct Player: Hashable, Identifiable, Codable {
    let id: Tagged<Self, UUID>
    var name: String = ""
}


extension Game {
    static let mock = Self(
        id: .init(rawValue: UUID()),
        title: "Mafia",
        players: [
            Player(id: .init(rawValue: UUID()), name: "Blob"),
            Player(id: .init(rawValue: UUID()), name: "Blob Jr."),
            Player(id: .init(rawValue: UUID()), name: "Blob Sr.")
        ]
    )
}
