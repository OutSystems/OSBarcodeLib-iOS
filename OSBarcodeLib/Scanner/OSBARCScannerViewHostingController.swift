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
}
