import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Utils.Palette.Basic.white.color)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Utils.Palette.Basic.red.color, Utils.Palette.Basic.black.color]),
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .opacity(self.isEnabled ? 1 : 0.5)
            .animation(.snappy, value: self.isEnabled)
    }
}

#Preview {
    Button("Primary Button") {
        print("Primary Button tapped")
    }
    .buttonStyle(PrimaryButtonStyle())
    .padding()
    .previewLayout(.sizeThatFits)
}
