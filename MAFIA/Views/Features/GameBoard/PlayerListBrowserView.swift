import SwiftUI

extension PlayerListBrowserView.ViewModel {
    enum State {
        case empty
        case loaded(list: [PlayerList])
    }

    enum Sheet: Identifiable {
        case addList

        var id: UUID { UUID() }
    }
}

extension PlayerListBrowserView {
    final class ViewModel: ObservableObject {
        @Published var state: State = .empty
        @Published var presentedSheet: Sheet?

        private(set) lazy var presenter: ListBrowserPresenter = .init(view: self)
        unowned let coordinator: any Coordinator<GameBoardScreen.Route>

        init(coordinator: some Coordinator<GameBoardScreen.Route>) {
            self.coordinator = coordinator
            self.presenter.showListPlayers()
        }
    }
}

extension PlayerListBrowserView.ViewModel: ListBrowserView {
    func setListPlayers(listPlayers: [PlayerList]) {
        if listPlayers.isEmpty == false {
            self.state = .loaded(list: listPlayers)
        }
    }
    
    func addNewList(listPlayer: PlayerList) {
        if case var .loaded(lists) = self.state {
            lists.append(listPlayer)
            self.state = .loaded(list: lists)
        }
        self.coordinator.navigate(to: .playerList(listPlayer))
    }
    
    func deleteList(listPlayer: PlayerList, indexPath: IndexPath) {
        guard case var .loaded(lists) = self.state else { return }
        guard let index = lists.firstIndex(of: listPlayer) else { return }
        lists.remove(at: index)
        self.state = .loaded(list: lists)
    }
    
    func showAlert(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style, completionFirstAction: (() -> Void)?) {

    }

}

struct PlayerListBrowserView: View {    
    @StateObject var viewModel: ViewModel

    var didSelectList: () -> Void

    var body: some View {
        Group {
            switch self.viewModel.state {
            case .empty:
                Text("EMPTY_LISTS".localized())
                    .title()
                    .multilineTextAlignment(.center)
            case .loaded(let lists):
                List {
                    ForEach(lists, id: \.name) { list in
                        HStack {
                            Text(list.name)
                                .subtitle()

                            Spacer()

                            Button(action: {
                                self.viewModel.presenter.selectList(list: list)
                                self.viewModel.coordinator.navigateBack()
                                self.didSelectList()
                            }, label: {
                                Text("USE_PLAYERS_LIST_BUTTON_TITLE".localized())
                                    .primaryButton()
                            })
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                self.viewModel.presenter.deleteList(playersList: list, indexPath: IndexPath())
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            self.viewModel.coordinator.navigate(to: .playerList(list))
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.viewModel.presentedSheet = .addList
                }, label: {
                    Image(icon: .plusList)
                })
            }
        }
        
        .sheet(item: self.$viewModel.presentedSheet) { sheet in
            switch sheet {
            case .addList:
                TextInputView(title: "ADD_LIST_MESSAGE".localized(), placeholder: "Lista 1") { name in
                    self.viewModel.presenter.createList(withName: name)
                    self.viewModel.presentedSheet = nil
                }
            }
        }
    }
}

#Preview("Empty") {
    final class MockCoordinator: Coordinator {
        var path: [GameBoardScreen.Route] = []
    }

    return NavigationStack {
        let coordinator = MockCoordinator()
        let viewModel = PlayerListBrowserView.ViewModel(coordinator: coordinator)
        viewModel.state = .empty
        return PlayerListBrowserView(viewModel: viewModel, didSelectList: { })
    }
}

#Preview("Lists") {
    final class MockCoordinator: Coordinator {
        var path: [GameBoardScreen.Route] = []
    }

    return NavigationStack {
        let coordinator = MockCoordinator()
        let viewModel = PlayerListBrowserView.ViewModel(coordinator: coordinator)

        return PlayerListBrowserView(viewModel: viewModel, didSelectList: { })
    }
}
