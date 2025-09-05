/// Allows mapping a to be defined `Model` to whatever class that it implements the protocol.
protocol OSBARCModelMappable {
    /// Type to use with the `map(_:)` method.
    associatedtype Model
    /// Maps an `Model` object into an object of the type of the class it implements
    /// - Parameter value: Value to map.
    /// - Returns: Resulting mapped value.
    static func map(_ value: Model) -> Self
}
