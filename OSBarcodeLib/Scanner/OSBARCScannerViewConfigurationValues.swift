import SwiftUI

struct OSBARCScannerViewConfigurationValues {
    static let mainColour: Color = .white
    static let secondaryColour: Color = .white.opacity(0.1)
    static let tertiaryColour: Color = .init(red: 0.314, green: 0.341, blue: 0.369)
    
    static let backgroundColour: Color = .black.opacity(0.65)
    
    static let defaultRadius: CGFloat = 4.0
    static let defaultLineStroke: CGFloat = 1.0
    
    static let screenPadding: CGFloat = 32.0
    static let scannerPadding: CGFloat = 16.0
    
    static let scannerLineSize: CGFloat = 50.0
    
    static let buttonSpacing: CGFloat = 24.0
}
