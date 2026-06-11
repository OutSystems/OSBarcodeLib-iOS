import SwiftUI

/// A Button that changes interface when clicking on it (like a Toggle). This is used for the torch
struct OSBARCTorchButton: View {
    /// The action performed when clicking the button.
    let action: () -> Void
    /// Indicates if the feature is enabled or not.
    let isOn: Bool
    /// The accessibility label read by screen readers when the torch is on.
    let onAccessibilityText: String
    /// The accessibility label read by screen readers when the torch is off.
    let offAccessibilityText: String

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
    /// Calculates the accessibility label to be used based on the toggle value.
    private var accessibilityText: String { isOn ? onAccessibilityText : offAccessibilityText }

    var body: some View {
        Button(action: action) {
            Image(iconName, bundle: Bundle.imageBundle)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .foregroundStyle(forColour: backgroundColour)
                )
                .if(!isOn) {
                    $0.overlay(
                        Circle()
                            .stroke(overlayColour, lineWidth: stroke)
                    )
                }
        }
        .accessibility(label: Text(accessibilityText))
    }
}

// MARK: - Bundle Extension
private extension Bundle {
    /// Returns the appropriate bundle for loading image assets.
    /// Uses Bundle.module for SwiftPM and falls back to the class bundle for CocoaPods.
    static var imageBundle: Bundle? {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: OSBARCScannerBehaviour.self)
        #endif
    }
}
