import SwiftUI

/// User Interface element to draw the button that allows cancelling the operation
/// It's shown as a white X on the screen.
struct OSBARCCancelButton: View {
    /// The action performed when the button is clicked.
    let action: () -> Void
    
    /// The icon to display..
    private let cancelIcon: String = "xmark"
    /// The scale to apply to the icon to display.
    private let cancelIconScale: Image.Scale = .large
    /// The color of the icon.
    private let foregroundColour: Color = OSBARCScannerViewConfigurationValues.mainColour
    /// The size of the button. It's applied to both width and height.
    private let buttonSize: CGFloat = 32.0
    
    var body: some View {
        Button(action: action) {
            Image(systemName: cancelIcon) // SF Symbols value.
                .imageScale(cancelIconScale)
                .foregroundStyle(forColour: foregroundColour)
        }
        .frame(width: buttonSize, height: buttonSize)
    }
}
