import SwiftUI

/// Class that hosts the `OSBARCScannerView` SwiftUI view.
class OSBARCScannerViewHostingController<Content>: UIHostingController<Content> where Content: View {
    /// Orientation the screen should adapt to.
    private var orientationModel: OSBARCOrientationModel
    
    /// Constructor method.
    /// - Parameters:
    ///   - rootView: The root view of the SwiftUI view hierarchy that you want to manage using the hosting view controller
    ///   - orientationModel: Orientation the screen should adapt to.
    init(rootView: Content, _ orientationModel: OSBARCOrientationModel) {
        self.orientationModel = orientationModel
        super.init(rootView: rootView)
    }
    
    /// Required method.. This is not used.
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .map(self.orientationModel) }

    /// Window scene the scanner is presented in, used to restore its orientation on dismissal.
    private weak var presentingWindowScene: UIWindowScene?
    /// Interface orientation in place before the scanner forced its own.
    private var previousInterfaceOrientation: UIInterfaceOrientation?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // With the UIScene lifecycle, presenting a full-screen controller with narrower
        // `supportedInterfaceOrientations` doesn't rotate the interface by itself,
        // so a forced orientation has to be requested explicitly.
        guard self.orientationModel != .adaptive,
              let windowScene = self.view.window?.windowScene
                ?? UIApplication.firstKeyWindowForConnectedScenes?.windowScene
        else { return }
        self.presentingWindowScene = windowScene
        self.previousInterfaceOrientation = windowScene.currentInterfaceOrientation
        Self.requestInterfaceOrientations(self.supportedInterfaceOrientations, in: windowScene, updating: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        guard let windowScene = self.presentingWindowScene,
              let previousInterfaceOrientation = self.previousInterfaceOrientation
        else { return }
        // Follow how the device is held now, if the app supports it.
        // Otherwise, go back to the orientation in place before scanning.
        let rootViewController = windowScene.keyWindow?.rootViewController
        let supportedOrientations = rootViewController?.supportedInterfaceOrientations ?? .all
        let deviceOrientation = UIInterfaceOrientation(deviceOrientation: UIDevice.current.orientation)
        let targetOrientation = deviceOrientation.flatMap {
            supportedOrientations.contains(.init(interfaceOrientation: $0)) ? $0 : nil
        } ?? previousInterfaceOrientation
        Self.requestInterfaceOrientations(
            .init(interfaceOrientation: targetOrientation), in: windowScene, updating: rootViewController
        )
    }

    /// Asks the window scene to rotate its interface to one of the given orientations.
    /// - Parameters:
    ///   - mask: The orientations to rotate to.
    ///   - windowScene: The window scene to rotate.
    ///   - viewController: The controller whose `supportedInterfaceOrientations` should be re-evaluated.
    private static func requestInterfaceOrientations(
        _ mask: UIInterfaceOrientationMask, in windowScene: UIWindowScene, updating viewController: UIViewController?
    ) {
        if #available(iOS 16.0, *) {
            viewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask))
        } else {
            let orientations: [UIInterfaceOrientation] = [
                .portrait, .landscapeRight, .landscapeLeft, .portraitUpsideDown
            ]
            guard let orientation = orientations.first(where: { mask.contains(.init(interfaceOrientation: $0)) })
            else { return }
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}
