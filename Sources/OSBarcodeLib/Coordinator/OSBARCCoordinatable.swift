/// Base class implemented by all classes that require UI interaction (push and dismiss operations).
class OSBARCCoordinatable {
    /// Object responsible for managing the user interface screens and respective flow.
    private(set) var coordinator: OSBARCCoordinatorProtocol
    
    /// Constructor.
    /// - Parameter coordinator: Object responsible for managing the user interface screens and respective flow.
    init(coordinator: OSBARCCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}
