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
    
    static func toVNBarcodeSymbologies(from hints: [OSBARCScannerHint]) -> [VNBarcodeSymbology] {
        guard !hints.isEmpty else { return OSBARCScannerHint.unknown.toVNBarcodeSymbologies() }
        var seen = Set<VNBarcodeSymbology>()
        var result: [VNBarcodeSymbology] = []
        for hint in hints {
            for symbology in hint.toVNBarcodeSymbologies() where !seen.contains(symbology) {
                seen.insert(symbology)
                result.append(symbology)
            }
        }
        return result
    }

    static func fromVNBarcodeSymbology(_ symbology: VNBarcodeSymbology, withHint hint: OSBARCScannerHint? = nil) -> OSBARCScannerHint {
        return fromVNBarcodeSymbology(symbology, withHints: hint.map { [$0] } ?? [])
    }

    static func fromVNBarcodeSymbology(_ symbology: VNBarcodeSymbology, withHints hints: [OSBARCScannerHint]) -> OSBARCScannerHint {
        if (symbology == .ean13) {
            // UPC-A and EAN-13 have similar format, and Apple Vision does not distinguish between the two
            // if a specific hint was provided, return that as the format
            // when both are allowed by `hints` the returned format is ambiguous; we default to .ean13 to match legacy single-hint behavior
            let hint: OSBARCScannerHint? = hints.contains(.ean13) ? .ean13 : (hints.contains(.upcA) ? .upcA : nil)
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
