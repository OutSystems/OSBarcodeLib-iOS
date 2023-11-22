import SwiftUI

/// A Button that changes interface when clicking on it (like a Toggle).
struct OSBARCToggleButton: View {
    /// The action performed when clicking the button.
    let action: () -> Void
    /// Indicates if the feature is enabled or not.
    let isOn: Bool
    
    /// Image name to be shown on the button.
    private let imageName: String = "flash"
    /// Height and width to use (the button is squared).
    private let size: CGFloat = 48.0
    /// Background colour to use when the toggle is set to `on`.
    private let selectedBackgroundColour: Color = OSBARCScannerViewConfigurationValues.mainColour
    /// Background colour to use then the togglet is set to `off`.
    private let notSelectedBackgroundColour: Color = OSBARCScannerViewConfigurationValues.secondaryColour
    /// Colour to use for the button's outer line.
    private let overlayColour: Color = OSBARCScannerViewConfigurationValues.tertiaryColour
    /// Width of the button's outer line.
    private let stroke: CGFloat = OSBARCScannerViewConfigurationValues.defaultLineStroke
    
    /// Calculates the icon name to be used based on the toggle value.
    private var iconName: String { "\(imageName)\(isOn ? "-selected" : "")" }
    /// Calculates the background colour to be used based on the toggle value.
    private var backgroundColour: Color { isOn ? selectedBackgroundColour : notSelectedBackgroundColour }
        
    var body: some View {
        Button(action: action) {
            Image(iconName, bundle: .init(for: OSBARCScannerBehaviour.self))    // xcassets item.
                .frame(width: size, height: size)
                .background(Circle().foregroundStyle(forColour: backgroundColour))
                .if(!isOn) {
                    $0.overlay(Circle().stroke(overlayColour, lineWidth: stroke))
                }
                .foregroundStyle(forColour: .clear)
        }
    }
}
