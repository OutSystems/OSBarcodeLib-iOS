import SwiftUI

extension View {
    /// Applies a colour to the View's foreground.
    /// - Parameter colour: Colour to be applied.
    /// - Returns: The resulting view.
    @ViewBuilder
    func foregroundStyle(forColour colour: Color) -> some View {
        if #available(iOS 15.0, *) {
            self.foregroundStyle(colour)
        } else {
            self.foregroundColor(colour)
        }
    }
}
