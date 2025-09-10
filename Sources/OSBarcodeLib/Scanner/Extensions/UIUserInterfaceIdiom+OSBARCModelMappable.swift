import UIKit

extension UIUserInterfaceIdiom: OSBARCDeviceTypeModelMappable {
    var deviceTypeModel: OSBARCDeviceTypeModel { self == .phone ? .iphone : .ipad }
}
