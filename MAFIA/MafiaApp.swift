import SwiftUI

@main
struct MafiaApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            GameBoardScreen()
        }
    }
}
