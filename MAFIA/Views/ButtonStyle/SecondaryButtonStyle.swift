import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.papyrus(size: .fontSize.medium))
            .foregroundColor(Utils.Palette.Basic.red.color)
            .padding(.spacing.small)
            .background {
                RoundedRectangle(cornerRadius: .cornerRadius.medium)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Utils.Palette.Basic.red.color,
                                    Utils.Palette.Basic.black.color
                                ]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .opacity(self.isEnabled ? 1 : 0.5)
            .animation(.snappy, value: self.isEnabled)
    }
}

#Preview {
    Button("Secondary Button") {
        print("Secondary Button tapped")
    }
    .buttonStyle(SecondaryButtonStyle())
    .padding()
    .previewLayout(.sizeThatFits)
}
