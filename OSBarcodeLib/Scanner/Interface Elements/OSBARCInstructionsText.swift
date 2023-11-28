import SwiftUI

/// The scanning instructions to be displayed on the screen, next to the scanning zone.
struct OSBARCInstructionsText: View {
    /// The text to be displayed.
    let instructionsText: String
    
    /// The colour to be used for the font.
    private let foregroundColour: Color = OSBARCScannerViewConfigurationValues.mainColour
    /// The colour to be used as the text's background.
    private let backgroundColour: Color = OSBARCScannerViewConfigurationValues.backgroundColour
    
    var body: some View {
        Text(instructionsText)
            .foregroundStyle(forColour: foregroundColour)
            .fixedSize(horizontal: false, vertical: true)   // allows the text to grow vertically in case of multiline text.
            .frame(maxWidth: .infinity, alignment: .center) // allows the text to grow horizontally, centering it on the view it's inserted on.
            .background(backgroundColour)
    }
}
