import SwiftUI

/// Structure responsible for bridging `OSBARCScannerViewController` into SwiftUI.
struct OSBARCScannerViewControllerRepresentable: UIViewControllerRepresentable {
    /// The object containing the value to return.
    @Binding var result: String
    
    func makeUIViewController(context: Context) -> OSBARCScannerViewController {
        let controller = OSBARCScannerViewController()
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: OSBARCScannerViewController, context: Context) {
        // Required but nothing to do here.
    }
    func makeCoordinator() -> OSBARCScannerViewControllerCoordinator {
        Coordinator($result)
    }
}
