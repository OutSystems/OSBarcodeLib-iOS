public struct OSBARCScanResult: Equatable {
    /// The actual textual data that was scanned
    public let text: String
    
    /// The format that was scanned, or `unknown` if unable to determine
    public let format: OSBARCScannerHint
}

extension OSBARCScanResult {
    static func empty() -> OSBARCScanResult {
        return OSBARCScanResult(text: "", format: .unknown)
    }
}
