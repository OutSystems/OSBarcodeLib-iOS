import UIKit

/// Protocol that allows pushing and poping views on top of the root view controller.
protocol OSBARCCoordinatorProtocol {
    /// Presents the passed view controller, adding it to the currently presented view controller array.
    /// - Parameter viewController: New view controller to present.
    func present(_ viewController: UIViewController)
    
    /// Dismisses the currently presented view controllers. In case of a multiple step screen, all are dismissed.
    func dismiss()
}
