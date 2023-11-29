import Combine
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
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Ignores safe area for different versions of iOS.
    /// - Returns: the View ignoring all safe areas.
    @ViewBuilder
    func customIgnoreSafeArea() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea()
        } else {
            self.edgesIgnoringSafeArea(.all)
        }
    }
    
    /// Adds a modifier for this view that fires an action when a specific value changes.
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - onChange: A closure to run when the value changes.
    /// - Returns: A view that fires an action when the specified value changes.
    @ViewBuilder
    func valueChanged<T: Equatable>(value: T, _ onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { onChange($0) }
        }
    }
}
