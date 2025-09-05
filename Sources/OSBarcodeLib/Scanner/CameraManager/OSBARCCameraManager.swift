import QuartzCore

/// Protocol that contains all the methods required for camera management.
protocol OSBARCCameraManager {
    /// The layer to display video on
    var videoPreview: CALayer? { get }
    
    /// Setup camera
    /// - Parameter type: The type of camera to setup. `Nil` value offers the possibility to setup a default camera provided by the implementations.
    func setup(type: OSBARCCameraType?) throws
    
    /// Apply changes to the camera.
    /// - Parameter change: The change to apply to the camera. It can be made to a property or to the camera itself.
    func apply(change: any OSBARCCameraChange) throws
    
    /// Initialises the camera display.
    func start()
    
    /// Terminates the camera display.
    func stop()
    
    /// Verifies if the camera passed by parameter is available for selection.
    /// - Parameter cameraType: The camera to be checked.
    /// - Returns: Indicates if the camera is available.
    func isAvailable(_ cameraType: OSBARCCameraType) throws -> Bool
    
    /// Retrieves the value associated with the passed property.
    /// - Parameter property: The property to fetch the value from (e.g. torch, zoom factors, ...).
    /// - Returns: The value associated with the passed property.
    func getValue<T>(forProperty property: OSBARCCameraProperty) throws -> T?
}

/// Accelerators.
extension OSBARCCameraManager {
    func setup() throws {
        try self.setup(type: nil)
    }
}
