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
                    .background(Color.white)
                    .clipShape(Circle())
            } else {
                Image(imageName, bundle: .init(for: OSBARCScannerBehaviour.self))
                    .frame(width: frame.width, height: frame.height)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 1.0)
                    )
            }
        }
    }
}
