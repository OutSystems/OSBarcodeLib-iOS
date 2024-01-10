import SwiftUI

/// The scanner's scanning zone.
/// It's composed by the "hole" and the aiming square outside it.
struct OSBARCScanningZone: View {
    /// The size of the scanning zone.
    let size: CGSize
    
    /// Considering the aim outside is a Rounded Rectangle, this is the radius of its vertices.
    private let radius: CGFloat = OSBARCScannerViewConfigurationValues.defaultRadius
    /// The colour of the aim's line.
    private let color: Color = OSBARCScannerViewConfigurationValues.mainColour
    /// Width of the aim's line.
    private let stroke: CGFloat = OSBARCScannerViewConfigurationValues.defaultLineStroke
    /// Length of the aim's line.
    private let lineSize: CGFloat = OSBARCScannerViewConfigurationValues.scannerLineSize
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .strokeBorder(color, style: .init(
                lineWidth: stroke, dash: self.calculateDashes(for: size), dashPhase: self.calculateDashPhase(for: size.height)
            ))
    }
}

// MARK: - Methods to calculate the Aim's Dash values.
private extension OSBARCScanningZone {
    /// Calculates the dashes to use the aim. It's a combination of line -> no line -> line -> no line (recursely).
    /// - Parameter scannerSize: Size to consider for the dashes.
    /// - Returns: The list of dashes to consider for the aim.
    func calculateDashes(for scannerSize: CGSize) -> [CGFloat] {
        let lineDash = lineSize * 2.0
        let heightDash = scannerSize.height - lineSize * 2.0    // squares have equal height and width dashes.
        let widthDash = scannerSize.width - lineSize * 2.0
        
        return [lineDash, heightDash, lineDash, widthDash]
    }
    
    /// Calculates where the dashes should start.
    /// - Parameter scannerHeight: The aim's height value.
    /// - Returns: The offset to apply when drawing the dashes.
    func calculateDashPhase(for scannerHeight: CGFloat) -> CGFloat { scannerHeight / 2.0 + lineSize + radius }
}
