import AVFoundation
import UIKit

/// All labels related with the `OSBARCPermissionsBehaviour` class.
private struct OSBARCPermissionsBehaviourLabels {
    static let dialogTitle = "Camera Access Not Enabled"
    static let dialogMessage = "To continue, please go to the Settings app and enable it."
    static let okButtonLabel = "OK"
    static let settingsButtonLabel = "Settings"
}

/// Object responsible to trigger the user interface and handle all user interactions required to validate if the device is ready for the library's actions.
final class OSBARCPermissionsBehaviour: OSBARCCoordinatable, OSBARCPermissionsProtocol {
    func hasCameraAccess() async -> Bool {
        // Since video access is required, validate video authorization status.
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // User has previously granted access to the camera so just return true.
            return true
        case .notDetermined:
            // User hasn't been presented with the option to grant video access
            // Time to fix it.
            return await self.requestCameraAccess()
        default:
            // User has previously denied access.
            return false
        }
    }
    
    /// Requests access to the device's camera.
    /// If not granted, it will display an Alert Controller to guide the user.
    private func requestCameraAccess() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    self.createAlertController()
                }
                
                continuation.resume(returning: granted)
            }
        }
    }
    
    /// Creates a `UIAlertController` that provides a shortcut to the user to the Settings app, to manage its current selections.
    private func createAlertController() {
        DispatchQueue.main.async {
            
            let title = NSLocalizedString(OSBARCPermissionsBehaviourLabels.dialogTitle, comment: "")
            let message = NSLocalizedString(OSBARCPermissionsBehaviourLabels.dialogMessage, comment: "")
            // the closure parameter indicates if the Settings screen should be opened.
            let actionClosure: (Bool) -> Void = { displaySettings in
                defer {
                    self.coordinator.dismiss()
                }
                
                if displaySettings, let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: NSLocalizedString(OSBARCPermissionsBehaviourLabels.okButtonLabel, comment: ""),
                style: .default
            ) { _ in
                actionClosure(false)
            }
            let settingsAction = UIAlertAction(
                title: NSLocalizedString(OSBARCPermissionsBehaviourLabels.settingsButtonLabel, comment: ""),
                style: .default
            ) { _ in
                actionClosure(true)
            }
            alertController.addAction(okAction)
            alertController.addAction(settingsAction)
            
            self.coordinator.present(alertController)
        }
    }
    
}
