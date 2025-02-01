import Foundation

protocol Coordinator<T>: AnyObject where T: Hashable {
    associatedtype T

    var path: [T] { get set }

    func navigate(to route: T)
    func navigateBack()
    func navigateBackToRoot()
}

// Default implementation
extension Coordinator {
    func navigate(to route: T) {
        self.path.append(route)
    }

    func navigateBack() {
        self.path.removeLast()
    }

    func navigateBackToRoot() {
        self.path.removeAll()
    }
}
