import XCTest
@testable import OSBarcodeLib

private extension OSBARCManager {
    func scanBarcode() async throws -> String {
        // `instructionText` and `buttonText` are UI-related so are irrelevant for the unit tests.
        try await self.scanBarcode(with: "Instruction Text", and: "Scan Button")
    }
}

final class OSBARCManagerTests: XCTestCase {
    private var permissionsBehaviour: OSBARCPermissionsStub!
    private var scannerBehaviour: OSBARCScannerStub!
    
    private var manager: OSBARCManager!
    
    override func setUpWithError() throws {
        self.permissionsBehaviour = OSBARCPermissionsStub()
        self.scannerBehaviour = OSBARCScannerStub()
        self.manager = OSBARCManager(permissionsBehaviour: self.permissionsBehaviour, scannerBehaviour: self.scannerBehaviour)
    }

    override func tearDownWithError() throws {
        self.manager = nil
        self.scannerBehaviour = nil
        self.permissionsBehaviour = nil
    }
    
    func testNoAccessToCameraShouldThrowException() async {
        self.permissionsBehaviour.error = .anError
        
        do {
            _ = try await self.manager.scanBarcode()
            XCTFail(OSBARCCommonValues.failMessage)
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testGivenAccessToCameraButCancelledScanShouldThrowException() async {
        self.scannerBehaviour.scanCancelled = true
        
        do {
            _ = try await self.manager.scanBarcode()
            XCTFail(OSBARCCommonValues.failMessage)
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testGivenAccessToCameraAndSuccessfulScanShouldReturnABarcode() async {
        do {
            let result = try await self.manager.scanBarcode()
            XCTAssertEqual(result, OSBARCScannerStubValues.scannedCode)
        } catch {
            XCTFail(OSBARCCommonValues.failMessage)
        }
    }
}
