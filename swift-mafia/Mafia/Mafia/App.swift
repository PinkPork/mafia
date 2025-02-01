import Sharing
import SwiftUI

struct AppView: View {
    @Shared(.path) var path

    var body: some View {
        NavigationStack(path: Binding($path)) {
            GameList()
                .navigationDestination(for: AppPath.self) { path in
                    switch path {
                    default: EmptyView()
                    }
                }
        }
    }
}

#Preview {
    AppView()
}
