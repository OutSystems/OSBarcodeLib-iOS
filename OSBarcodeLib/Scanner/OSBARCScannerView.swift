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
    
    /// Text to be shown in the Scan Button.
    let buttonText: String
    /// Indicates if the button should be shown.
    let shouldShowButton: Bool
    /// Indicates if scanning is enabled. It's only applied when there's a Scan Button visible (otherwise, scanning is automatically).
    @State var buttonScanEnabled: Bool = false
    
    /// Orientation the screen should adapt to.
    let orientationModel: OSBARCOrientationModel
    
    /// The type of device being used.
    let deviceType: OSBARCDeviceTypeModel
    
    /// The horizontal visual size available.
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    /// The vertical visual size available.
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    /// Indicates if we're dealing with an iPhone on Portrait mode or not.
    private var isPhoneInPortrait: Bool { horizontalSizeClass == .compact && verticalSizeClass == .regular }
    
    // MARK: - UI Elements
    /// The padding to apply to the screen's limit sides.
    private let screenPadding: CGFloat = OSBARCScannerViewConfigurationValues.screenPadding
    /// The padding between the scanning zone's aim and hole.
    private let scannerPadding: CGFloat = OSBARCScannerViewConfigurationValues.scannerPadding
    /// The spacing between the buttons (used on iPads and iPhones on Landscape mode).
    private let buttonSpacing: CGFloat = OSBARCScannerViewConfigurationValues.buttonSpacing
    
    /// Draws the background view (black with a little transparency).
    /// - Parameters:
    ///   - height: The height to use, if any.
    ///   - width: The width to use, if any.
    /// - Returns: Returns the view to display.
    @ViewBuilder
    private func backgroundView(height: CGFloat? = nil, width: CGFloat? = nil) -> some View {
        OSBARCScannerViewConfigurationValues.backgroundColour
            .if(height != nil) {
                $0.frame(height: height ?? 0.0) // the fallback value will never be executed
            }
            .if(width != nil) {
                $0.frame(width: width ?? 0.0) // the fallback value will never be executed
            }
    }
    
    /// Cancel button.
    private var cancelButton: OSBARCCancelButton {
        .init {
            scanResult = "" // cancelling translates in scanResult being empty.
        }
    }
    
    /// Scanning Instructions Text Field.
    private var instructionsTextField: OSBARCInstructionsText {
        .init(instructionsText: instructionsText)
    }
    
    /// Scanning Button. It needs to enabled to appear.
    private var scanButton: OSBARCScanButton {
        OSBARCScanButton(action: {
            buttonScanEnabled = true
        }, text: buttonText)
    }
    
    /// The scanning zone, containing the aim and the hole.
    /// - Parameter size: The size to use for the view
    /// - Returns: The view adapted to the parameter size.
    @ViewBuilder
    private func scanningZone(for size: CGSize) -> some View {
        let scannerSize: CGSize = calculateSize(for: size)
        
        ZStack(alignment: .topLeading) {
            // inner background view
            OSBARCBackgroundView(padding: scannerPadding, size: scannerSize)
            
            // Scanning Zone
            OSBARCScanningZone(size: scannerSize)
        }
        .frame(width: scannerSize.width, height: scannerSize.height)
    }
    
    /// A view that contains the Scanning Zone and the Scanning Instructions Text Field.
    /// It's used on iPads and iPhones on Landscape mode.
    @ViewBuilder
    private var scanningZoneWithInstructions: some View {
        // Scan Instructions
        instructionsTextField
        
        backgroundView(height: scannerPadding)
        
        GeometryReader {
            scanningZone(for: $0.size)
        }
        .layoutPriority(1)
    }
    
    /// Toggle button.
    private var toggleButton: OSBARCToggleButton {
        .init(action: {
            isTorchButtonOn.toggle()
            changeTorchMode()
        }, isOn: isTorchButtonOn)
    }
    
    // MARK: - Main Element
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Camera Stream
            OSBARCScannerViewControllerRepresentable(captureDevice, $scanResult, shouldShowButton, $buttonScanEnabled, orientationModel)
            
            // Background Black View
            GeometryReader { proxy in
                OSBARCBackgroundView(padding: screenPadding, size: proxy.size)
            }
            
            if isPhoneInPortrait {
                VStack(spacing: 0.0) {
                    // X View
                    ZStack {
                        backgroundView()
                        
                        HStack {
                            Spacer()
                            
                            // Cancel Button
                            cancelButton
                        }
                    }
                    
                    backgroundView(height: screenPadding)
                    
                    GeometryReader { scannerProxy in
                        VStack(spacing: 0.0) {
                            backgroundView()
                            
                            // Scan Instructions
                            instructionsTextField
                            
                            backgroundView(height: screenPadding)
                            
                            scanningZone(for: scannerProxy.size)
                            
                            backgroundView()
                        }
                    }
                    .layoutPriority(1)
                    
                    backgroundView(height: screenPadding)
                    
                    // Buttons View
                    ZStack {
                        backgroundView()
                        
                        ZStack(alignment: .trailing) {
                            // Scan Button
                            scanButton
                            .opacity(!shouldShowButton ? 0.0 : 1.0)
                            .disabled(!shouldShowButton)
                            .frame(maxWidth: .infinity)
                            
                            // Torch Button
                            toggleButton
                            .opacity(!cameraHasTorch ? 0.0 : 1.0)
                            .disabled(!cameraHasTorch)                            
                        }
                    }
                }
                .padding(screenPadding)
            } else {
                GeometryReader { mainProxy in
                    HStack(spacing: 0.0) {
                        backgroundView()
                        
                        VStack(spacing: 0.0) {
                            backgroundView()
                            
                            if deviceType == .iphone {
                                scanningZoneWithInstructions
                            } else {
                                VStack(spacing: 0.0) {
                                    scanningZoneWithInstructions
                                }
                                .frame(height: min(mainProxy.size.width, mainProxy.size.height) * 0.5)
                            }
                            
                            backgroundView()
                        }
                        .frame(width: mainProxy.size.width * 0.5 - scannerPadding * 2.0)
                        
                        backgroundView(width: screenPadding)
                        
                        // Buttons View
                        ZStack(alignment: .trailing) {
                            backgroundView()
                            
                            VStack(alignment: .trailing, spacing: buttonSpacing) {
                                // Cancel Button
                                cancelButton
                                
                                Spacer()
                                
                                if cameraHasTorch {
                                    // Torch Button
                                    toggleButton
                                }
                                
                                if shouldShowButton {
                                    // Scan Button
                                    scanButton
                                }
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }.padding(screenPadding)
            }
        }
        .customIgnoreSafeArea()
    }
}

// MARK: - UI Elements Helper Methods
private extension OSBARCScannerView {
    /// Configures `captureDevice` to turn on or off its torch light.
    func changeTorchMode() {
        try? captureDevice?.lockForConfiguration()
        captureDevice?.torchMode = isTorchButtonOn ? .on : .off
        captureDevice?.unlockForConfiguration()
    }
    
    /// Calculates the size to use based on the available screen size.
    /// - Parameter proxySize: The available screen size.
    /// - Returns: The size to use for the view that calls the method.
    func calculateSize(for proxySize: CGSize) -> CGSize {
        .init(
            width: proxySize.width,
            height: isPhoneInPortrait ? proxySize.width : proxySize.height  // iPhone in portrait uses a square scanning zone.
        )
    }
}
