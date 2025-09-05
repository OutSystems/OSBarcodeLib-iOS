import SwiftUI

/// Background view that is displayed behind the interface elements (a black view with a little transparency).
/// Since the view has a "hole" in the middle, in reality is composed by 4 rectangles, one for each side of the hole.
struct OSBARCBackgroundView: View {
    /// Frame of portion of the screen used for scanning.
    let scanFrame: CGRect
    
    /// Colour to be displayed as the background.
    private let colour: Color = OSBARCScannerViewConfigurationValues.backgroundColour
    /// Radius to apply on the vertices.
    private let radius: CGFloat = OSBARCScannerViewConfigurationValues.defaultRadius
    
    var body: some View {        
        ZStack(alignment: .topLeading) {
            colour
            
            RoundedRectangle(cornerRadius: radius)
                .blendMode(.destinationOut)
                .offset(x: scanFrame.minX, y: scanFrame.minY)
                .frame(width: scanFrame.width, height: scanFrame.height)
        }.compositingGroup()
    }
}
