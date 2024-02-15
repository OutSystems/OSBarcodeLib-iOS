import AVFoundation
import SwiftUI

/// The library's main view.
struct OSBARCScannerView: View {
    /// View model with all the camera logic.
    @ObservedObject var viewModel: OSBARCScannerViewModel
    
    /// The object containing the scanned value.
    @Binding var scanResult: String
    
    /// Helper text to display.
    let instructionsText: String
    
    /// Text to be shown in the Scan Button.
    let buttonText: String
    /// Indicates if the button should be shown.
    let shouldShowButton: Bool
    /// Indicates if scanning is enabled. It's only applied when there's a Scan Button visible (otherwise, scanning is automatically).
    @State private var buttonScanEnabled: Bool = false
    
    /// The type of device being used.
    let deviceType: OSBARCDeviceTypeModel
    
    /// Frame of portion of the screen used for scanning.
    @State private var scanFrame: CGRect = .zero
    
    /// The horizontal visual size available.
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    /// The vertical visual size available.
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    /// Indicates if we're dealing with an iPhone on Portrait mode or not.
    private var isPhoneInPortrait: Bool { horizontalSizeClass == .compact && verticalSizeClass == .regular }
    
    // MARK: - UI Elements
    /// The padding to apply to the screen's limit sides.
    private let screenPadding: CGFloat = OSBARCScannerViewConfigurationValues.screenPadding
    /// A smaller padding than the screen one.
    private let smallerPadding: CGFloat = OSBARCScannerViewConfigurationValues.smallerPadding
    /// The spacing between the buttons (used on iPads and iPhones on Landscape mode).
    private let buttonSpacing: CGFloat = OSBARCScannerViewConfigurationValues.buttonSpacing
    
    /// View filled with the background colour
    private var backgroundView: OSBARCBackgroundView {
        .init(scanFrame: scanFrame)
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
            buttonScanEnabled.toggle()
            // everytime `scanButtonSelection` changes, the notification is triggered so that the barcode detection can be enabled/disabled.
            NotificationCenter.default.post(name: .scanButtonSelection, object: buttonScanEnabled)
            if buttonScanEnabled {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }, text: buttonText, isOn: buttonScanEnabled)
    }
    
    /// The scanning zone, containing the aim and the hole.
    /// - Parameter size: The size to use for the view
    /// - Returns: The view adapted to the parameter size.
    @ViewBuilder
    private func scanningZone(for size: CGSize) -> some View {
        let scannerSize: CGSize = calculateSize(for: size)
        
        // Scanning Zone
        GeometryReader { scanningZoneProxy in
            OSBARCScanningZone(size: scannerSize)
                .onAppear(perform: {
                    let scanningZoneFrame = scanningZoneProxy.frame(in: .global)
                    scanFrame = .init(
                        x: scanningZoneFrame.minX + smallerPadding,
                        y: scanningZoneFrame.minY + smallerPadding,
                        width: scanningZoneFrame.width - 2.0 * smallerPadding,
                        height: scanningZoneFrame.height - 2.0 * smallerPadding
                    )
                })
                .valueChanged(value: scanFrame) {
                    // everytime `scanFrame` changes, the notification is triggered so that the barcode detection region gets updated.
                    NotificationCenter.default.post(name: .scanFrameChanged, object: $0)
                }
        }
        .frame(width: scannerSize.width, height: scannerSize.height)
    }
    
    /// A view that contains the Scanning Zone and the Scanning Instructions Text Field.
    /// It's used on iPads and iPhones on Landscape mode.
    @ViewBuilder
    private var scanningZoneWithInstructions: some View {
        // Scan Instructions
        instructionsTextField
        
        GeometryReader {
            scanningZone(for: $0.size)
        }
        .layoutPriority(1)
    }
    
    /// Toggle button.
    private var torchButton: OSBARCTorchButton {
        .init(action: {
            viewModel.isTorchButtonOn.toggle()
        }, isOn: viewModel.isTorchButtonOn)
    }
    
    private var zoomSelectorView: OSBARCZoomSelectorView? {
        try? .init(zoomFactorArray: viewModel.zoomFactorArray, currentZoomFactor: viewModel.selectedZoomFactor) {
            viewModel.selectedZoomFactor = $0
        }
    }
    
    // MARK: - Main Element
    var body: some View {
        ZStack {
            // Camera Stream
            OSBARCScannerViewControllerRepresentable(viewModel.cameraManager)
            
            backgroundView
            
            if isPhoneInPortrait {
                VStack(spacing: screenPadding) {
                    // X View
                    HStack {
                        Spacer()
                        
                        // Cancel Button
                        cancelButton
                    }
                    
                    GeometryReader { scannerProxy in
                        VStack(spacing: screenPadding) {
                            // Scan Instructions
                            instructionsTextField
                            // Scanning Zone
                            scanningZone(for: scannerProxy.size)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    }
                    
                    // Buttons View
                    ZStack(alignment: .bottomTrailing) {
                        VStack(spacing: smallerPadding) {
                            if viewModel.shouldShowZoomSelectorView {
                                // Zoom Selector View
                                zoomSelectorView
                            }
                            
                            if shouldShowButton {
                                // Scan Button
                                scanButton
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Torch Button
                        torchButton
                            .opacity(!viewModel.cameraHasTorch ? 0.0 : 1.0)
                            .disabled(!viewModel.cameraHasTorch)
                    }
                }
                .padding(screenPadding)
            } else {
                GeometryReader { mainProxy in
                    HStack(spacing: smallerPadding) {
                        Color.clear
                        
                        VStack {
                            Spacer()
                            
                            if deviceType == .iphone {
                                scanningZoneWithInstructions
                            }
                            // Despite the similarities between the following views,
                            // this is required so that `scanFrame` gets correctly updated
                            else if mainProxy.size.width < mainProxy.size.height {
                                VStack(spacing: smallerPadding) {
                                    scanningZoneWithInstructions
                                }
                                .frame(height: mainProxy.size.width * 0.5)
                            } else {
                                VStack(spacing: smallerPadding) {
                                    scanningZoneWithInstructions
                                }
                                .frame(height: mainProxy.size.height * 0.5)
                            }
                            
                            Spacer()
                        }
                        .frame(width: mainProxy.size.width * 0.5 - smallerPadding * 2.0)
                        
                        // Buttons View
                        VStack(alignment: .trailing, spacing: buttonSpacing) {
                            // Cancel Button
                            cancelButton
                            
                            Spacer()
                            
                            if viewModel.cameraHasTorch {
                                // Torch Button
                                torchButton
                            }
                            
                            if viewModel.shouldShowZoomSelectorView {
                                // Zoom Selector View
                                zoomSelectorView
                            }
                            
                            if shouldShowButton {
                                // Scan Button
                                scanButton
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }.padding(screenPadding)
            }
        }
        .customIgnoreSafeArea()
        .statusBarHidden(true)
    }
}

// MARK: - UI Elements Helper Methods
private extension OSBARCScannerView {
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
