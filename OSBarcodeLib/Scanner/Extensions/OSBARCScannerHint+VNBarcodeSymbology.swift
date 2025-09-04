import Foundation
import Vision

extension OSBARCScannerHint {
    func toVNBarcodeSymbologies() -> [VNBarcodeSymbology] {
        if let specificSymbiology = self.toVNBarcodeSymbology() {
            return specificSymbiology
        } else {
            return self.allBarcodeTypes
        }
    }
    
    static func fromVNBarcodeSymbology(_ symbology: VNBarcodeSymbology, withHint hint: OSBARCScannerHint? = nil) -> OSBARCScannerHint {
        if (symbology == .ean13) {
            // UPC-A and EAN-13 have similar format, and Apple Vision does not distinguish between the two
            // if a specific hint was provided, return that as the format
            switch hint {
                case .upcA: return .upcA
                case .ean13: return .ean13
                default: break
            }
        }
        return Self.hintMappings.first { (_, symbologies) in
            symbologies.contains(symbology)
        }?.key ?? .unknown
    }
    
    static let hintMappings: [OSBARCScannerHint: [VNBarcodeSymbology]] = {
        var result: [OSBARCScannerHint: [VNBarcodeSymbology]] = [
            .qrCode: [.qr],
            .aztec: [.aztec],
            .code39: [.code39],
            .code93: [.code93],
            .code128: [.code128],
            .dataMatrix: [.dataMatrix],
            .itf: [.itf14, .i2of5],
            .ean13: [.ean13],
            .ean8: [.ean8],
            .pdf417: [.pdf417],
            .upcA: [.ean13],
            .upcE: [.upce]
        ]

        if #available(iOS 15.0, *) {
            result[.codabar] = [.codabar]
            result[.rss14] = [.gs1DataBar]
            result[.rssExpanded] = [.gs1DataBarExpanded]
        }

        return result
    }()

    private func toVNBarcodeSymbology() -> [VNBarcodeSymbology]? {
        return Self.hintMappings[self]
    }

    private var allBarcodeTypes: [VNBarcodeSymbology] {
        var result = Self.hintMappings.values.flatMap { $0 }
        if #available(iOS 15.0, *) {
            result += [.microPDF417, .microQR]
        }
        return result
    }
}
