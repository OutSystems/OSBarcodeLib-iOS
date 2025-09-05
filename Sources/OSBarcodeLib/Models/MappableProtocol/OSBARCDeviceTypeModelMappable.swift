/// Provides a mapping from a structure or class to an object of `OSBARCDeviceTypeModel` type.
protocol OSBARCDeviceTypeModelMappable {
    /// Identifies the type of the device where the plugin is currently running on.
    var deviceTypeModel: OSBARCDeviceTypeModel { get }
}
