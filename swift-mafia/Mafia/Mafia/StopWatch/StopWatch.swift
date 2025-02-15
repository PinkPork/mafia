import SwiftUI

struct StopWatchContentView: View {
    let stopwatch = Stopwatch()

    var body: some View {
        VStack {
            Text(stopwatch.totalFormatted)
                .font(.headline).monospacedDigit()

            HStack {
                Button(action: {
                    if self.stopwatch.isRunning {
                        self.stopwatch.stop()
                        self.stopwatch.reset()
                    } else {
                        self.stopwatch.start()
                    }
                }) {
                    Text(self.stopwatch.isRunning ? "Stop" : "Start")
                        .padding(4)
                }
                .foregroundColor(self.stopwatch.isRunning ? .red : .green)
                .buttonStyle(CircleStyle())
                .frame(width: 100)
            }
        }
    }
}

private struct ButtonCircle: ViewModifier {
    let isPressed: Bool

    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .background(
                Circle()
                    .fill()
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .opacity(isPressed ? 0.3 : 0)
                    )
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                            .padding(4)
                    )
            )
    }
}

private struct CircleStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label.modifier(ButtonCircle(isPressed: configuration.isPressed))
    }
}


#Preview {
    StopWatchContentView()
}
