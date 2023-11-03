import Combine
import SwiftUI

/// Class responsible for the barcode scanner view flow.
final class OSBARCScannerBehaviour: OSBARCCoordinatable, OSBARCScannerProtocol {
    /// A publisher value responsible for the resulting scanned value.
    @Published private var scanResult: String = ""
    /// The publisher's cancellable instance collector.
    private var cancellables: Set<AnyCancellable> = []
    
    func startScanning(_ completion: @escaping (String) -> Void) {
        $scanResult
            .dropFirst()    // drops the first value - the empty string
            .first()        // only publishes the first barcode value found
            .sink {
                self.coordinator.dismiss()
                completion($0)
            }
            .store(in: &cancellables)
        
        let scanResultBinding = Binding(    // binding object filled by the SwiftUI view
            get: {
                self.scanResult
            },
            set: {
                self.scanResult = $0
            }
        )
        let scannerView = OSBARCScannerView(scanResult: scanResultBinding)
        let hostingController = UIHostingController(rootView: scannerView)
        
        self.coordinator.present(hostingController)
    }
}
