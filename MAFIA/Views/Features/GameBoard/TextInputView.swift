import SwiftUI

struct TextInputView: View {
    let title: String
    let placeholder: String
    var action: (String) -> Void

    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            Text(self.title)
                .custom(size: .fontSize.extraSmall)

            PrimaryTextField(label: self.placeholder, text: self.$text)
                .padding()
                .focused(self.$isFocused)

            Button(action: {
                self.action(self.text)
            }, label: {
                Text("ADD_ACTION".localized())
                    .primaryButton()
                    .padding(.horizontal)
            })
            .disabled(self.text.isEmpty)
            .buttonStyle(PrimaryButtonStyle())
        }
        .task {
            await MainActor.run {
                self.isFocused = true
            }
        }
    }
}

struct PrimaryTextField: View {
    let label: String
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
    TextInputView(title: "Add Text", placeholder: "placrholder") { _ in

    }
}
