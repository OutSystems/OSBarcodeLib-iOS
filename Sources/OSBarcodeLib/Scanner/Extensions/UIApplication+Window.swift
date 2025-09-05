import UIKit

extension UIApplication {
    /// The application's main window.
    static var firstKeyWindowForConnectedScenes: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
    }
}
