/// Enumerator with the possible camera to use for video input collection.
public enum OSBARCCameraModel {
    case back
    case front
}

/// Allows mapping a `OSBARCCameraModel` to whatever class that it implements the protocol.
protocol OSBARCCameraModelMappable {
    /// Maps an `OSBARCCameraModel` object into an object of the type of the class it implements
    /// - Parameter value: Value to map.
    /// - Returns: Resulting mapped value.
    static func map(_ value: OSBARCCameraModel) -> Self
}
