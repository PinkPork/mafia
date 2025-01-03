import Foundation

extension CGFloat {
    static var spacing: Spacing.Type { Spacing.self }
    static var cornerRadius: CornerRadius.Type { CornerRadius.self }
    static var fontSize: FontSize.Type { FontSize.self }
    static var borderWidth: BorderWidth.Type { BorderWidth.self }
    static var iconSize: IconSize.Type { IconSize.self }
}

enum FontSize {
    static var extraSmall: CGFloat { 14 }
    static var small: CGFloat { 16 }
    static var medium: CGFloat { 18 }
    static var large: CGFloat { 24 }
    static var extraLarge: CGFloat { 36 }
}

enum Spacing {
    static var small: CGFloat { 8 }
    static var medium: CGFloat { 16 }
    static var large: CGFloat { 24 }
    static var extraLarge: CGFloat { 36 }
}

enum CornerRadius {
    static var small: CGFloat { 8 }
    static var medium: CGFloat { 16 }
    static var large: CGFloat { 24 }
}

enum BorderWidth {
    static var thin: CGFloat { 1 }
    static var medium: CGFloat { 2 }
    static var thick: CGFloat { 4 }
}

enum IconSize {
    static var small: CGFloat { 24 }
    static var medium: CGFloat { 36 }
    static var large: CGFloat { 48 }
}
