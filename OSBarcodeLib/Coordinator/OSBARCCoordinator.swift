import UIKit

/// Object responsible for managing the screen flow, in response to the user's interaction.
struct OSBARCCoordinator {
    /// Root view controller, from whom every view gets pushed on top of.
    private let rootViewController: UIViewController
    
    /// Construtor.
    /// - Parameter rootViewController: Root view controller, from whom every view gets pushed on top of.
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

/// Implements the `OSBARCCoordinatorProtocol` methods
extension OSBARCCoordinator: OSBARCCoordinatorProtocol {
    func present(_ viewController: UIViewController) {
        self.rootViewController.present(viewController, animated: true)
    }
    
    func dismiss() {
        self.rootViewController.dismiss(animated: true)
    }
}
