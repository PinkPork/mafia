import Foundation
import Sharing

enum AppPath: Codable, Hashable {
    case gameDetail(id: Game.ID)
    case game(id: Game.ID)
    case match(id: Game.ID, match: Match.ID?)

    var isRestorable: Bool {
        switch self {
        case .gameDetail: true
        case .game: true
        case .match: false
        }
    }
}

extension SharedReaderKey where Self == FileStorageKey<[AppPath]>.Default {
    static var path: Self {
        Self[
            .fileStorage(
                .documentsDirectory.appending(path: "path.json"),
                decode: { data in
                    try JSONDecoder().decode([AppPath].self, from: data)
                },
                encode: { path in
                    try JSONEncoder().encode(path.filter(\.isRestorable))
                }
            ),
            default: []
        ]
    }
}
