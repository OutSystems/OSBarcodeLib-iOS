import SwiftUI

/// Button that, when enabled, allows the user to start the scan processing
struct OSBARCScanButton: View {
    /// The action performed when the button is clicked.
    let action: () -> Void
    /// Text to be shown on the button.
    let text: String
    /// Indicates if the feature is enabled or not.
    let isOn: Bool
    
    /// Text colour to use when the button's feature is set to `on`
    private let selectedForegroundColour: Color = OSBARCScannerViewConfigurationValues.tertiaryColour
    /// Text colour to use when the button's feature is set to `off`
    private let notSelectedForegroundColour: Color = OSBARCScannerViewConfigurationValues.mainColour
    /// Background colour to use when the button's feature is set to `on`.
    private let selectedBackgroundColour: Color = OSBARCScannerViewConfigurationValues.mainColour
    /// Background colour to use when the button's feature is set to `off`.
    private let notSelectedBackgroundColour: Color = OSBARCScannerViewConfigurationValues.secondaryColour
    /// The colour of the button's outer line.
    private let overlayColour: Color = OSBARCScannerViewConfigurationValues.tertiaryColour
    /// Considering the button is displayed as a Rounded Rectangle, this is the radius of the button's vertices.
    private let cornerRadius: CGFloat = OSBARCScannerViewConfigurationValues.defaultRadius
    /// Width of the button's outer line.
    private let stroke: CGFloat = OSBARCScannerViewConfigurationValues.defaultLineStroke
    
    /// Calculates the text colour to be used based on the `isOn` value.
    private var foregroundColour: Color { isOn ? selectedForegroundColour : notSelectedForegroundColour }
    /// Calculates the background colour to be used based on the `isOn` value.
    private var backgroundColour: Color { isOn ? selectedBackgroundColour : notSelectedBackgroundColour }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .padding()
                .foregroundStyle(forColour: foregroundColour)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(backgroundColour)
                )
                .if(!isOn) {
                    $0.overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(overlayColour, style: .init(lineWidth: stroke))
                    )
                }
        }
    }
}
