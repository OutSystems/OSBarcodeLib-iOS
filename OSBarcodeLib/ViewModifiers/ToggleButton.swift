import SwiftUI

/// A Button that changes interface when clicking on it (like a Toggle).
struct ToggleButton: View {
    /// Image name to be shown on the button.
    var imageName: String
    /// Indicates if the feature is enabled or not.
    var isOn: Bool
    /// The size to consider for the button.
    var frame: CGSize
    /// The action performed when clicking the button.
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if isOn {
                Image("\(imageName)-selected", bundle: .init(for: OSBARCScannerBehaviour.self))    // xcassets item.
                    .frame(width: frame.width, height: frame.height)
                    .background(
                        Circle()
                            .foregroundStyle(forColour: OSBARCScannerViewConfigurationValues.mainColour)
                    )
            } else {
                Image(imageName, bundle: .init(for: OSBARCScannerBehaviour.self))
                    .frame(width: frame.width, height: frame.height)
                    .background(
                        Circle()
                            .foregroundStyle(forColour: OSBARCScannerViewConfigurationValues.secondaryColour)
                    )
                    .overlay(
                        Circle()
                            .stroke(OSBARCScannerViewConfigurationValues.tertiaryColour, lineWidth: 1.0)
                    )
                    
            }
        }
    }
}
