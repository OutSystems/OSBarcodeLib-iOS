import SwiftUI

struct OSBARCZoomButton: View {
    /// The action performed when clicking the button.
    let action: () -> Void
    /// Value to apply when button is selected.
    let zoomFactor: Float
    /// Indicates if the zoom factor is applied.
    let isSelected: Bool
    
    /// `zoomFactor` text value to display.
    private var text: String {
        "\(zoomFactor.clean)\(isSelected ? "x" : "")"
    }
    /// Button size. Since it's rounded, it's equivalent to its diameter.
    private let buttonSize: CGFloat = 36.0
    /// Button colour to display.
    private var backgroundColour: Color {
        .black.opacity(isSelected ? 0.5 : 0.2)
    }
    /// Size of the text font.
    private let fontSize: CGFloat = 12.0
    /// Text colour to display.
    private var textColour: Color {
        isSelected ? .init(red: 0.961, green: 0.624, blue: 0) : OSBARCScannerViewConfigurationValues.mainColour
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundStyle(forColour: textColour)
                .frame(width: buttonSize, height: buttonSize)
                .background(
                    Circle()
                        .foregroundStyle(forColour: backgroundColour)
                )
        }
    }
}

struct OSBARCZoomButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OSBARCZoomButtonTestView(zoomFactor: 1.0)
            OSBARCZoomButtonTestView(isSelected: true, zoomFactor: 1.0)
            
            OSBARCZoomButtonTestView(zoomFactor: 0.5)
            OSBARCZoomButtonTestView(isSelected: true, zoomFactor: 0.5)
        }
    }
    
    struct OSBARCZoomButtonTestView: View {
        @State var isSelected: Bool = false
        let zoomFactor: Float
            
        var body: some View {
            VStack {
                OSBARCZoomButton(
                    action: {
                        isSelected.toggle()
                    },
                    zoomFactor: zoomFactor,
                    isSelected: isSelected)
                
                Text("Button is \(isSelected ? "" : "not ")selected.")
                    .foregroundStyle(forColour: .white)
            }
            .background(OSBARCScannerViewConfigurationValues.backgroundColour)
            .previewLayout(.sizeThatFits)
        }
    }
}
