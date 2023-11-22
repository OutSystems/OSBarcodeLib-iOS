import SwiftUI

/// Button that, when enabled, allows the user to start the scan processing
struct OSBARCScanButton: View {
    /// The action performed when the button is clicked.
    let action: () -> Void
    /// Text to be shown on the button.
    let text: String
    
    /// Colour to be set to the text.
    private let foregroundColour: Color = OSBARCScannerViewConfigurationValues.mainColour
    /// The colour to display outside the text.
    private let backgroundColour: Color = OSBARCScannerViewConfigurationValues.secondaryColour
    /// The colour of the button's outer line.
    private let overlayColour: Color = OSBARCScannerViewConfigurationValues.tertiaryColour
    /// Considering the button is displayed as a Rounded Rectangle, this is the radius of the button's vertices.
    private let cornerRadius: CGFloat = OSBARCScannerViewConfigurationValues.defaultRadius
    /// Width of the button's outer line.
    private let stroke: CGFloat = OSBARCScannerViewConfigurationValues.defaultLineStroke
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .padding()
                .foregroundStyle(forColour: foregroundColour)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(overlayColour, style: .init(lineWidth: stroke))
                )
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(backgroundColour)
                )
        }
    }
}
