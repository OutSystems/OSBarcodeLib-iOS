import XCTest
@testable import OSBarcodeLib

private extension OSBARCManager {
    func scanBarcode() async throws -> OSBARCScanResult {
        // `instructionText`, `buttonText`, `cameraModel` and `orientationModel` are UI-related so are irrelevant for the unit tests.
        try await self.scanBarcode(
            with: OSBARCScanParameters(
                scanInstructions: "Instruction Text",
                scanButtonText: "Scan Button",
                cameraDirection: .back,
                scanOrientation: .adaptive,
                hint: .qrCode
            )
        )
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
        
        await self.assertThrowsAsyncError(try await self.manager.scanBarcode()) {
            XCTAssertEqual($0 as? OSBARCManagerError, OSBARCManagerError.cameraAccessDenied)
        }
    }
    
    func testGivenAccessToCameraButCancelledScanShouldThrowException() async {
        self.scannerBehaviour.scanCancelled = true
        
        await self.assertThrowsAsyncError(try await self.manager.scanBarcode()) {
            XCTAssertEqual($0 as? OSBARCManagerError, OSBARCManagerError.scanningCancelled)
        }
    }
    
    func testGivenAccessToCameraAndSuccessfulScanShouldReturnABarcode() async throws {
        let result = try await self.manager.scanBarcode()
        XCTAssertEqual(result, OSBARCScannerStubValues.scannedCode)
    }
}

private extension OSBARCManagerTests {
    func assertThrowsAsyncError<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            let customMessage = message()
            if customMessage.isEmpty {
                XCTFail("Asynchronous call did not throw an error.", file: file, line: line)
            } else {
                XCTFail(customMessage, file: file, line: line)
            }
        } catch {
            errorHandler(error)
        }
    }
}
