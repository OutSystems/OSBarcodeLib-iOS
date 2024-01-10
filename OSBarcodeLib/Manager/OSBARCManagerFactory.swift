import UIKit

/// Structure responsible for creating the scanner flow manager..
public struct OSBARCManagerFactory {
    /// Creates the scanner flow manager.
    /// - Parameter rootViewController: Root view controller, from whom every view gets pushed on top of.
    /// - Returns: The resulting scanner flow manager.
    public static func createManager(with rootViewController: UIViewController) -> OSBARCManagerProtocol {
        let coordinator = OSBARCCoordinator(rootViewController: rootViewController)
        // it calls the `OSBARCManager`'s convenience constructor.
        return OSBARCManager(coordinator: coordinator)
    }
}
