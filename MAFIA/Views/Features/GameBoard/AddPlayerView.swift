import SwiftUI

struct AddPlayerView: View {
    var addPlayerAction: (String) -> Void

    @State private var playerName: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            Text("ADD_PLAYER_MESSAGE".localized())
                .custom(size: .fontSize.extraSmall)

            NameTextField(label: "Jugador X", text: self.$playerName)
                .padding()
                .focused(self.$isFocused)

            Button(action: {
                self.addPlayerAction(self.playerName)
            }, label: {
                Text("ADD_ACTION".localized())
                    .primaryButton()
                    .padding(.horizontal)
            })
            .disabled(self.playerName.isEmpty)
            .buttonStyle(PrimaryButtonStyle())
        }
        .task {
            await MainActor.run {
                self.isFocused = true
            }
        }
    }
}

private struct NameTextField: View {
    let label: LocalizedStringKey
    @Binding var text: String

    @Environment(\.isEnabled) private var isEnabled: Bool

    var body: some View {
        TextField(self.label, text: self.$text)
            .font(.papyrus(size: .fontSize.small))
            .padding()
            .border(self.isEnabled ? Utils.Palette.Basic.red.color : Utils.Palette.Basic.veryLightGrey.color, width: .borderWidth.thin)
    }
}

#Preview {
    AddPlayerView { _ in

    }
}
