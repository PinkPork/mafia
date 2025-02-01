import Sharing
import SwiftUI

struct AppView: View {
    @Shared(.path) var path

    var body: some View {
        NavigationStack(path: Binding($path)) {
            GameListView()
                .navigationDestination(for: AppPath.self) { path in
                    switch path {
                    case .gameDetail(let id):
                        GameDetailView(id: id)
                    case .game(id: let id):
                        GameMatchView(id: id)
                    }
                }
        }
    }
}

#Preview {
    AppView()
}
