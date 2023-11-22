import SwiftUI

/// Background view that is displayed behind the interface elements (a black view with a little transparency).
/// Since the view has a "hole" in the middle, in reality is composed by 4 rectangles, one for each side of the hole.
struct OSBARCBackgroundView: View {
    /// The smallest size (height/width) to be used to draw the side rectangle
    let padding: CGFloat
    /// The biggest size (height/width) to be used to draw the side rectangle.
    let size: CGSize
    
    /// Colour to be displayed as the background.
    private let colour: Color = OSBARCScannerViewConfigurationValues.backgroundColour
    
    var body: some View {
        // left side
        colour
            .frame(width: padding, height: size.height)
        // right side
        colour
            .frame(width: padding, height: size.height)
            .offset(x: size.width - padding)
        // top side
        colour
            .frame(width: size.width - padding * 2.0, height: padding)
            .offset(x: padding)
        // bottom side
        colour
            .frame(width: size.width - padding * 2.0, height: padding)
            .offset(x: padding, y: size.height - padding)
    }
}
