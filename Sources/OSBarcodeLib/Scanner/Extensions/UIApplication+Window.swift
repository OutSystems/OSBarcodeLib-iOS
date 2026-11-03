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

    /// The current interface orientation of the key window's scene.
    static var currentInterfaceOrientation: UIInterfaceOrientation? {
        self.firstKeyWindowForConnectedScenes?.windowScene?.currentInterfaceOrientation
    }
}

extension UIWindowScene {
    /// The scene's current interface orientation, read from `effectiveGeometry` on iOS 16+
    /// (`interfaceOrientation` is deprecated as of iOS 26).
    var currentInterfaceOrientation: UIInterfaceOrientation {
        if #available(iOS 16.0, *) { return self.effectiveGeometry.interfaceOrientation }
        return self.interfaceOrientation
    }
}
