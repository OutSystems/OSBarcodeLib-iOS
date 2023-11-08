import AVFoundation
import SwiftUI

/// The library's main view.
struct OSBARCScannerView: View {
    /// The camera used to capture video for barcode scanning.
    let captureDevice: AVCaptureDevice?
    
    /// The object containing the scanned value.
    @Binding var scanResult: String
    /// Indicates if the camera selected for scanning has a torch.
    let cameraHasTorch: Bool
    /// Indicates current torch value.
    @State var isTorchButtonOn: Bool = false
    /// Helper text to display.
    let instructionsText: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Camera Stream
            OSBARCScannerViewControllerRepresentable(result: $scanResult, captureDevice: captureDevice)
            
            VStack {
                HStack {
                    Spacer()
                    
                    // Cancel Button
                    Button {
                        scanResult = "" // cancelling translates in scanResult being empty.
                    } label: {
                        Image(systemName: "xmark")  // SF Symbols value.
                            .imageScale(.large)
                            .foregroundStyle(forColour: .white)
                    }
                }
                
                Text(instructionsText)
                    .padding(.vertical)
                
                Spacer()
                HStack {
                    Spacer()
                    // Torch Button
                    ToggleButton(imageName: "flash", isOn: isTorchButtonOn, frame: .init(width: 48.0, height: 48.0)) {
                        isTorchButtonOn.toggle()
                        changeTorchMode()
                    }
                    .opacity(!cameraHasTorch ? 0.0 : 1.0)
                    .disabled(!cameraHasTorch)
                }
            }
            .padding(32)
        }
    }
    
    /// Configures `captureDevice` to turn on or off its torch light.
    func changeTorchMode() {
        try? captureDevice?.lockForConfiguration()
        captureDevice?.torchMode = isTorchButtonOn ? .on : .off
        captureDevice?.unlockForConfiguration()
    }
}
