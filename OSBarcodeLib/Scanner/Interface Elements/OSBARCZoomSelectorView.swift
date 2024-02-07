import SwiftUI

struct OSBARCZoomSelectorView: View {
    /// All possible zoom factors that can be applied.
    let zoomFactorArray: [Float]
    /// The currently selected zoom factor.
    let currentZoomFactor: Float
    /// Action triggered when a new zoom factor value is selected.
    let changedZoomFactor: (Float) -> Void
    
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
                        if currentZoomFactor != zoomFactor {    // only change when it's different
                            changedZoomFactor(zoomFactor)
                        }
                    },
                    zoomFactor: zoomFactor,
                    isSelected: currentZoomFactor == zoomFactor)
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
            OSBARCZoomSelectorTestView(zoomFactorSelected: 1.0, zoomFactorArray: [0.5, 1.0, 2.0])
                .previewLayout(.sizeThatFits)
            
            OSBARCZoomSelectorTestView(zoomFactorSelected: 2.0, zoomFactorArray: [0.5, 1.0, 2.0])
                .previewLayout(.sizeThatFits)
        }
        .background(OSBARCScannerViewConfigurationValues.backgroundColour)
    }
    
    struct OSBARCZoomSelectorTestView: View {
        @State var zoomFactorSelected: Float
        let zoomFactorArray: [Float]
        
        var body: some View {
            VStack {
                OSBARCZoomSelectorView(zoomFactorArray: zoomFactorArray, currentZoomFactor: zoomFactorSelected) {
                    zoomFactorSelected = $0
                }
                
                Text("Zoom factor currently selected: \(zoomFactorSelected.clean)x.")
                    .foregroundStyle(forColour: .white)
            }
            .background(OSBARCScannerViewConfigurationValues.backgroundColour)
            .previewLayout(.sizeThatFits)
        }
    }
}
