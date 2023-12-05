import AVFoundation
import SwiftUI
import UIKit

/// Class responsible for displaying the camera stream that performs the scanning.
final class OSBARCScannerViewController: UIViewController {
    /// Object that coordinates the follow between the input device to the capture output.
    private let captureSession = AVCaptureSession()
    /// Layer that displays video from the device's camera.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    /// Object that manages the reception of sample buffers from a video data output.
    private let delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    /// The camera used to capture video for barcode scanning.
    private let captureDevice: AVCaptureDevice?
    
    /// Orientation the screen should adapt to.
    private let orientationModel: OSBARCOrientationModel
    
    /// Constructor method
    /// - Parameters:
    ///   - delegate: Object that manages the reception of sample buffers from a video data output.
    ///   - captureDevice: The camera used to capture video for barcode scanning.
    ///   - orientationModel: Orientation the screen should adapt to.
    init(delegate: AVCaptureVideoDataOutputSampleBufferDelegate?, captureDevice: AVCaptureDevice?, orientationModel: OSBARCOrientationModel) {
        self.delegate = delegate
        self.captureDevice = captureDevice
        self.orientationModel = orientationModel
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Required method. This is not used.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the property camera for capturing videos
        guard let captureDevice else {
            print("Failed to get the camera device")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            // Get an instance of the `AVCaptureDeviceInput` class using the previous device object.
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        // Set the input device on the capture session.
        captureSession.addInput(videoInput)
        
        let deviceOutput = AVCaptureVideoDataOutput()
        // Set the quality of the video
        deviceOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        // What we will display on the screen
        captureSession.addOutput(deviceOutput)
        
        // Initialise the video preview layer and add it as a sublayer to the view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
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
            } else if let screenBounds = self.view.window?.windowScene?.screen.bounds {
                initialVideoOrientation = screenBounds.width > screenBounds.height ? .landscapeRight : .portrait
            }
            
            self.videoPreviewLayer?.connection?.videoOrientation = initialVideoOrientation ?? .portrait
        }
        
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        if let videoPreviewLayerConnection = videoPreviewLayer?.connection {
            let deviceOrientation = UIDevice.current.orientation
            guard let newVideoOrientation = AVCaptureVideoOrientation(deviceOrientation: deviceOrientation)
            else { return }
            
            videoPreviewLayerConnection.videoOrientation = newVideoOrientation
        }
    }
}
