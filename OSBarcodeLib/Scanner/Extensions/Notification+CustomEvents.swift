import Foundation

extension Notification.Name {
    /// Notification triggered when barcode's scan frame gets changed.
    static let scanFrameChanged = Notification.Name("scanFrameChanged")
    /// Notification triggered when the scan barcode button gets enabled or disabled.
    static let scanButtonSelection = Notification.Name("scanButtonSelection")
}
