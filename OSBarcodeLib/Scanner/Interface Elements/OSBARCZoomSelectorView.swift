import SwiftUI

struct OSBARCZoomSelectorView: View {
    /// All possible zoom factors that can be applied
    let zoomFactorArray: [Float]
    /// The currently selected zoom factor.
    @Binding var selectedZoomFactor: Float
    
    /// Spacing between the different buttons that compose the selector.
    private let spacing: CGFloat = 8.0
    /// Padding between the outer view and the button stack.
    private let padding: CGFloat = 4.0
    /// Considering the aim outside is a Rounded Rectangle, this is the radius of its vertices.
    private let cornerRadius: CGFloat = 54.0
    /// Colour of the button stack.
    private let viewBackgroundColour: Color = OSBARCScannerViewConfigurationValues.secondaryColour
    /// Colour of the outside border line.
    private let borderColour: Color = OSBARCScannerViewConfigurationValues.tertiaryColour
    /// Width of the outside border line.
    private let borderStroke: CGFloat = OSBARCScannerViewConfigurationValues.defaultLineStroke
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(zoomFactorArray, id: \.self) { zoomFactor in
                OSBARCZoomButton(
                    action: {
                        // only change when it's different
                        if selectedZoomFactor != zoomFactor {
                            selectedZoomFactor = zoomFactor
                        }
                    },
                    zoomFactor: zoomFactor,
                    isSelected: selectedZoomFactor == zoomFactor)
            }
        }
        .padding(padding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(forColour: viewBackgroundColour)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(borderColour, lineWidth: borderStroke)
        )
    }
}

struct OSBARCZoomSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OSBARCZoomSelectorView(zoomFactorArray: [1.0], selectedZoomFactor: .constant(1.0))
                .previewLayout(.sizeThatFits)
            OSBARCZoomSelectorView(zoomFactorArray: [0.5, 1.0, 2.0], selectedZoomFactor: .constant(1.0))
                .previewLayout(.sizeThatFits)
            OSBARCZoomSelectorView(zoomFactorArray: [0.5, 1.0, 2.0], selectedZoomFactor: .constant(0.5))
                .previewLayout(.sizeThatFits)
            OSBARCZoomSelectorView(zoomFactorArray: [0.5, 1.0], selectedZoomFactor: .constant(2.0))
                .previewLayout(.sizeThatFits)
        }
        .background(OSBARCScannerViewConfigurationValues.backgroundColour)
    }
}
