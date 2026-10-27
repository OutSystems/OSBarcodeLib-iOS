import UIKit

extension UIInterfaceOrientationMask: OSBARCModelMappable {
    static var deviceTypeModel: OSBARCDeviceTypeModel { UIDevice.current.userInterfaceIdiom.deviceTypeModel }
    
    static func map(_ value: OSBARCOrientationModel) -> UIInterfaceOrientationMask {
        switch value {
        case .portrait: return .portrait
        case .landscape: return .landscape
        default: return Self.deviceTypeModel == .iphone ? .allButUpsideDown : .all
        }
    }

    /// Mask containing only the given interface orientation (`all` when it's unknown).
    /// - Parameter interfaceOrientation: Value to be converted from.
    init(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: self = .all
        }
    }
}

extension UIInterfaceOrientation {
    /// Interface orientation matching the device's physical orientation.
    /// Returns `nil` when the device is flat or the orientation is unknown.
    /// - Parameter deviceOrientation: Value to be converted from.
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight     // the landscape cases are mirrored between device and interface
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
}
