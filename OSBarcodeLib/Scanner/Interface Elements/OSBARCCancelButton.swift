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
    /// The colour of the icon.
    private let foregroundColour: Color = OSBARCScannerViewConfigurationValues.mainColour
    /// The size of the button. It's applied to both width and height.
    private let buttonSize: CGFloat = 36.0
    /// Separation between the icon and the button's border.
    private let iconPadding: CGFloat = 10.0
    /// Button colour.
    private let backgroundColour: Color = .black.opacity(0.25)
    
    var body: some View {
        Button(action: action) {
            Image(systemName: cancelIcon) // SF Symbols value.
                .imageScale(cancelIconScale)
                .foregroundStyle(forColour: foregroundColour)
                .padding(iconPadding)
        }
        .frame(width: buttonSize, height: buttonSize)
        .background(
            Circle()
                .foregroundStyle(forColour: backgroundColour)
        )
    }
}
