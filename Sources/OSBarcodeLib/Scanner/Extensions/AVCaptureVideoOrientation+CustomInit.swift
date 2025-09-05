import AVFoundation
import UIKit

/// Extension that maps a `UIDeviceOrientation` into an `AVCaptureVideoOrientation`.
extension AVCaptureVideoOrientation {
    /// Mapper construtor.
    /// - Parameter interfaceOrientation: Value to be converted from.
    init?(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        case .unknown: return nil
        @unknown default: return nil
        }
    }
}
