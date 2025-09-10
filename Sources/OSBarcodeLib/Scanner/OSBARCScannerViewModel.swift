import Combine
import SwiftUI

class OSBARCScannerViewModel: ObservableObject {
    /// Object responsible for managing all things camera related.
    private(set) var cameraManager: OSBARCCameraManager
    
    /// Indicates if the camera selected for scanning has a torch.
    @Published var cameraHasTorch: Bool
    /// Indicates current torch value.
    @Published var isTorchButtonOn: Bool = false
    
    /// Array with all the possible zoom factor values.
    let zoomFactorArray: [Float]
    /// Indicates if the zoom selector should be shown.
    let shouldShowZoomSelectorView: Bool
    /// Indicates the currently selected zoom factor value.
    @Published var selectedZoomFactor: Float = OSBARCScannerViewConfigurationValues.defaultZoom
    
    /// The publisher's cancellable instance collector.
    private var cancellables: Set<AnyCancellable> = []
    
    /// Constructor method.
    /// - Parameter cameraManager: Object responsible for managing all things camera related.
    init(cameraManager: OSBARCCameraManager) throws {
        try cameraManager.setup()
        let zoomFactorArray: [Float] = try cameraManager.getValue(forProperty: .zoomFactor) ?? []
        let torchEnabled: Bool = try cameraManager.getValue(forProperty: .torch) ?? false
        
        self.zoomFactorArray = zoomFactorArray
        self.shouldShowZoomSelectorView = zoomFactorArray.count > 1
        self.cameraHasTorch = torchEnabled
        
        self.cameraManager = cameraManager
        
        $isTorchButtonOn
            .dropFirst()
            .sink { try? cameraManager.apply(change: OSBARCCameraTorchChange(value: $0)) }
            .store(in: &cancellables)
        
        $selectedZoomFactor
            .removeDuplicates()
            .sink(receiveCompletion: { [weak self] _ in
                let torchEnabled: Bool? = try? cameraManager.getValue(forProperty: .torch)
                self?.cameraHasTorch = torchEnabled ?? false
            }, receiveValue: {
                try? cameraManager.apply(change: OSBARCCameraZoomFactorChange(value: $0))
            })
            .store(in: &cancellables)
    }
}
