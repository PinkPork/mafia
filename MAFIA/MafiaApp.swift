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

private struct MainView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() ?? UIViewController()
        return mainViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
