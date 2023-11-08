import AVFoundation
import UIKit

/// Class responsible for displaying the camera stream that performs the scanning.
final class OSBARCScannerViewController: UIViewController {
    /// Object that coordinates the follow between the input device to the capture output.
    private var captureSession = AVCaptureSession()
    /// Layer that displays video from the device's camera.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    /// Object that manages the reception of sample buffers from a video data output.
    var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
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
        
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
        
        super.viewWillDisappear(animated)
    }
}
