import Sharing
import SwiftUI

struct AppView: View {
    @Shared(.path) var path
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    var body: some View {
        NavigationStack(path: Binding($path)) {
            GameListView()
                .id(appLanguage)
                .navigationDestination(for: AppPath.self) { path in
                    switch path {
                    case .gameDetail(let id):
                        GameDetailView(id: id)
                    case .game(id: let id):
                        GameMatchView(id: id, roleReveal: true)
                    case let .match(id: gameId, match: matchId):
                        GameMatchView(id: gameId, matchId: matchId)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Picker("Language", selection: $appLanguage) {
                                Text("English").tag("en")
                                Text("Español").tag("es")
                            }
                        } label: {
                            Image(systemName: "globe")
                        }
                    }
                }
        }
        .environment(\.locale, Locale(identifier: appLanguage))
    }
}

#Preview {
    AppView()
}
