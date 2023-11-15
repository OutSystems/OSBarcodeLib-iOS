import AVFoundation
import UIKit

/// Extension that maps a `UIDeviceOrientation` into an `AVCaptureVideoOrientation`.
extension AVCaptureVideoOrientation {
    /// Mapper construtor.
    /// - Parameter deviceOrientation: Value to be converted from.
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
}
