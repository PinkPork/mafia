import SwiftUI

extension Font {
    static func papyrus(size: CGFloat) -> Font {
        return .custom("PAPYRUS_FONT".localized(), size: size)
    }
}

extension Text {
    func title() -> Text {
        return self
            .custom(size: .fontSize.extraLarge)
            .foregroundColor(Utils.Palette.Basic.gray.color)
    }

    func subtitle() -> Text {
        return self
            .custom(size: .fontSize.large)
            .foregroundColor(Utils.Palette.Basic.black.color)
    }

    func primaryButton() -> Text {
        return self
            .custom(size: .fontSize.medium)
            .foregroundColor(Utils.Palette.Basic.white.color)
            .bold()
    }

    func body() -> Text {
        return self
            .custom(size: .fontSize.small)
    }

    func custom(size: CGFloat) -> Text {
        return self
            .font(.papyrus(size: size))
    }
}
