import Foundation

final class Stopwatch: ObservableObject {
    @Published private var data = StopwatchData()
    private var timer: Timer?

    var totalFormatted: String {
        data.totalTime.formatted
    }

    var isRunning: Bool {
        data.absoluteStartTime != nil
    }

    func start() {
        DispatchQueue.global(qos: .background).async {
            self.timer = Timer(timeInterval: 0.01, repeats: true, block: { [unowned self] timer in

                DispatchQueue.main.async {
                    self.data.currentTime = Date().timeIntervalSinceReferenceDate
                }
            })

            RunLoop.current.add(self.timer!, forMode: .default)
            RunLoop.current.run()
        }

        data.start(at: Date().timeIntervalSinceReferenceDate)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        data.stop()
    }

    func reset() {
        stop()
        data = StopwatchData()
    }

    deinit {
        stop()
    }
}

private struct StopwatchData {
    var absoluteStartTime: TimeInterval?
    var currentTime: TimeInterval = 0
    var additionalTime: TimeInterval = 0

    var totalTime: TimeInterval {
        guard let start = absoluteStartTime else { return additionalTime }
        return additionalTime + currentTime - start
    }

    mutating func start(at time: TimeInterval) {
        currentTime = time
        absoluteStartTime = time
    }

    mutating func stop() {
        additionalTime = totalTime
        absoluteStartTime = nil
    }
}

extension TimeInterval {
    var formatted: String {
        let ms = self.truncatingRemainder(dividingBy: 1)
        return formatter.string(from: self)! + numberFormatter.string(from: NSNumber(value: ms))!
    }
}

private let formatter: DateComponentsFormatter = {
    let dateComponentsFormatter = DateComponentsFormatter()
    dateComponentsFormatter.allowedUnits = [.minute, .second]
    dateComponentsFormatter.zeroFormattingBehavior = .pad
    return dateComponentsFormatter
}()

private let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.maximumIntegerDigits  = 0
    numberFormatter.alwaysShowsDecimalSeparator = true
    return numberFormatter
}()
