/// Interface that manages and handles the actions related with access and authorisation to the device's camera.
protocol OSBARCPermissionsProtocol {
    /// Checks if the device has authorisation to access its camera. On the first time, it requests the user for access, displaying an alert if not granted.
    /// - Returns: A boolean indicating if access was given or not.
    func hasCameraAccess() async -> Bool
}
