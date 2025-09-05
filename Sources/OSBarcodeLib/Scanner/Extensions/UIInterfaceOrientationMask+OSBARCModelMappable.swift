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
}
