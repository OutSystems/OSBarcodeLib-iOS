import AVFoundation
import UIKit

/// Errors associated with the `OSBARCCaptureSessionManager`.
enum OSBARCCaptureSessionManagerError: Error {
    case couldntCreateDeviceInput
    case couldntRetrieveActiveCamera
}

/// An implementation of the `OSBARCCameraManager` that uses the `AVCaptureDevice` for video display.
final class OSBARCCaptureSessionManager: OSBARCCameraManager {
    var videoPreview: CALayer?
    
    /// List of available cameras to use.
    let captureDevices: [AVCaptureDevice]
    /// Orientation the screen should adapt to.
    let orientationModel: OSBARCOrientationModel
    /// Class responsible for decoding the camera output.
    let outputDecoder: OSBARCCaptureOutputDecoder
    
    /// Maps the camera types fo the zoom factor. This is required as 0.5x zooming requires a different camera.
    private var cameraZoomMap: [Float: OSBARCCameraType] = [
        0.5: .zoomOut,
        1.0: .regular,
        2.0: .regular
    ]
    
    /// Object that coordinates the follow between the input device to the capture output.
    private let captureSession = AVCaptureSession()
    
    /// Constructor method.
    /// - Parameters:
    ///   - cameraModel: Camera to use for capturing (front or back).
    ///   - orientationModel: Orientation the screen should adapt to.
    ///   - barcodeDecoder: Class responsible for decoding the camera output.
    init(_ cameraModel: OSBARCCameraModel, _ orientationModel: OSBARCOrientationModel, _ barcodeDecoder: OSBARCCaptureOutputDecoder) {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [OSBARCCameraType.regular, .zoomOut].map(\.deviceType)
        let cameraPosition = AVCaptureDevice.Position.map(cameraModel)
        let captureDevices = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: cameraPosition).devices
        
        self.captureDevices = captureDevices
        self.orientationModel = orientationModel
        self.outputDecoder = barcodeDecoder
    }
    
    func setup(type cameraType: OSBARCCameraType?) throws {
        // select camera to start with. The order is the following;
        // 1 - the passed by parameter one
        // 2 - the one associated with the `defaultZoom`
        // 3 - regular
        let cameraType = cameraType ?? self.cameraZoomMap[OSBARCScannerViewConfigurationValues.defaultZoom] ?? .regular
        
        // Get the property camera for capturing videos
        guard let captureDevice = self.captureDevices.filter({ $0.deviceType == cameraType.deviceType }).first else {
            throw OSBARCCameraManagerError.cameraNotConfigured(cameraType)
        }
        
        let deviceInput: AVCaptureDeviceInput
        do {
            // Get an instance of the `AVCaptureDeviceInput` class using the previous device object.
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            throw OSBARCCaptureSessionManagerError.couldntCreateDeviceInput
        }
        
        if self.captureSession.canAddInput(deviceInput) {
            // Set the input device on the capture session.
            self.captureSession.addInput(deviceInput)
            
            let deviceOutput = AVCaptureVideoDataOutput()
            // Set the quality of the video
            deviceOutput.setSampleBufferDelegate(self.outputDecoder, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
            
            if self.captureSession.canAddOutput(deviceOutput) {
                // What we will display on the screen
                self.captureSession.addOutput(deviceOutput)
                
                // Initialise the video preview layer and add it as a sublayer to the view's layer.
                let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                videoPreviewLayer.videoGravity = .resizeAspectFill
                self.videoPreview = videoPreviewLayer
                
                DispatchQueue.main.async {
                    /*
                     Why are we dispatching this to the main queue?
                     Because `AVCaptureVideoPreviewLayer` is the backing layer for `PreviewView` and `UIView`
                     can only be manipulated on the main thread.
                     Note: As an exception to the above rule, it is not necessary to serialize video orientation changes
                     on the `AVCaptureVideoPreviewLayer`’s connection with other session manipulation.
                     
                     Calculate the initial video orientation based on the device and the selection screen orientation.
                     Subsequent orientation changes are handled by `viewWillTransition(to:with:)`.
                     */
                    let deviceOrientation = UIDevice.current.orientation
                    var initialVideoOrientation = AVCaptureVideoOrientation(deviceOrientation: deviceOrientation)
                    
                    /*
                     If the orientation has to be portrait but the device is not on that mode, orientation is set to `portrait`.
                     If the orientation has to be landscape but the device is not on that mode, orientation is set to `landscapeRight`.
                     
                     If the device is set to `flat` orientation, then check screen size to understand it's portrait or landscape.
                     */
                    if self.orientationModel == .portrait, !deviceOrientation.isPortrait {
                        initialVideoOrientation = .portrait
                    } else if self.orientationModel == .landscape, !deviceOrientation.isLandscape {
                        initialVideoOrientation = .landscapeRight
                    } else if let screenBounds = UIApplication.firstKeyWindowForConnectedScenes?.windowScene?.screen.bounds {
                        initialVideoOrientation = screenBounds.width > screenBounds.height ? .landscapeRight : .portrait
                    }
                    
                    videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation ?? .portrait
                }
            }
        }
    }
    
    func isAvailable(_ cameraType: OSBARCCameraType) -> Bool {
        !self.captureDevices.filter { $0.deviceType == cameraType.deviceType }.isEmpty
    }
    
    func apply(change: any OSBARCCameraChange) throws {
        switch change.property {
        case .zoomFactor:
            if let zoomFactorChange = change as? OSBARCCameraZoomFactorChange {
                var cameraTypeToUse: OSBARCCameraType
                let zoomFactorValueToUse: Float
                
                if zoomFactorChange.value == 0.5 {
                    // This implies using a new camera type. Despite the 0.5 value, the value will be `1.0` with the zoomOut camera.
                    cameraTypeToUse = .zoomOut
                    zoomFactorValueToUse = 1.0
                } else {
                    cameraTypeToUse = .regular
                    zoomFactorValueToUse = zoomFactorChange.value
                }
                
                try self.change(toCameraType: cameraTypeToUse, zoomFactorValue: zoomFactorValueToUse)
            }
        case .torch:
            if let torchChange = change as? OSBARCCameraTorchChange {
                try self.change(torchValue: torchChange.value)
            }
        case .none: // this means a change to the camera itself, with the rotation being the only available change.
            if let rotationChange = change as? OSBARCCameraRotationChange, let videoPreviewLayer = videoPreview as? AVCaptureVideoPreviewLayer {
                videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: rotationChange.value.width, height: rotationChange.value.height)
                
                if let videoPreviewLayerConnection = videoPreviewLayer.connection {
                    let deviceOrientation = UIDevice.current.orientation
                    guard let newVideoOrientation = AVCaptureVideoOrientation(deviceOrientation: deviceOrientation)
                    else { return }
                    
                    videoPreviewLayerConnection.videoOrientation = newVideoOrientation
                }
            }
        }
    }
    
    func getValue<T>(forProperty property: OSBARCCameraProperty) throws -> T? {
        switch property {
        case .zoomFactor:
            let captureDeviceTypes = Set(self.captureDevices.map(\.deviceType))
            let zoomFactorArray = self.cameraZoomMap.filter { captureDeviceTypes.contains($0.value.deviceType) }.keys.compactMap { $0 }.sorted(by: <)
            return zoomFactorArray as? T
        case .torch:
            guard let captureDeviceInput = self.captureSession.inputs.first as? AVCaptureDeviceInput else {
                throw OSBARCCaptureSessionManagerError.couldntRetrieveActiveCamera
            }
            return captureDeviceInput.device.hasTorch as? T
        }
    }
    
    func start() {
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    func stop() {
        // Stop video capture.
        DispatchQueue.global(qos: .background).async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
}

private extension OSBARCCaptureSessionManager {
    /// Apply change to the passed camera type.
    /// - Parameters:
    ///   - newCameraType: The camera type to assume with the change. If no value is passed, it will assume the current camera.
    ///   - newTorchValue: The new torch value to assume. If no value is passed, no change to the torch will be made.
    ///   - newZoomFactorValue: The new zoom factor value to assume. If no value is passed, no change to the zoom factor will be made.
    func change(toCameraType newCameraType: OSBARCCameraType? = nil, torchValue newTorchValue: Bool? = nil, zoomFactorValue newZoomFactorValue: Float? = nil) throws {
        guard let captureDeviceInput = self.captureSession.inputs.first as? AVCaptureDeviceInput else {
            throw OSBARCCaptureSessionManagerError.couldntRetrieveActiveCamera
        }
        
        let captureDeviceToUse: AVCaptureDevice
        var torchValueToUse: Bool?
        let zoomFactorValueToUse: Float?
        
        if let newCameraType, captureDeviceInput.device.deviceType != newCameraType.deviceType {
            guard let newCaptureDevice = self.captureDevices.filter({ $0.deviceType == newCameraType.deviceType }).first else {
                throw OSBARCCameraManagerError.cameraNotConfigured(newCameraType)
            }
            if newCaptureDevice.hasTorch {
                torchValueToUse = captureDeviceInput.device.torchMode == .on
            }
            zoomFactorValueToUse = newZoomFactorValue
            
            self.captureSession.beginConfiguration()
            
            self.captureSession.removeInput(captureDeviceInput)
            
            let newDeviceInput: AVCaptureDeviceInput
            do {
                // Get an instance of the `AVCaptureDeviceInput` class using the previous device object.
                newDeviceInput = try AVCaptureDeviceInput(device: newCaptureDevice)
            } catch {
                throw OSBARCCaptureSessionManagerError.couldntCreateDeviceInput
            }
            
            if self.captureSession.canAddInput(newDeviceInput) {
                self.captureSession.addInput(newDeviceInput)
            }
            
            self.captureSession.commitConfiguration()
            
            captureDeviceToUse = newCaptureDevice
        } else {
            captureDeviceToUse = captureDeviceInput.device
            torchValueToUse = newTorchValue
            zoomFactorValueToUse = newZoomFactorValue
        }
        
        DispatchQueue.global(qos: .background).async {
            try? captureDeviceToUse.lockForConfiguration()
            if let torchValueToUse {
                captureDeviceToUse.torchMode = torchValueToUse ? .on : .off
            }
            if let zoomFactorValueToUse {
                captureDeviceToUse.videoZoomFactor = CGFloat(zoomFactorValueToUse)
            }
            captureDeviceToUse.unlockForConfiguration()
        }
    }
}
