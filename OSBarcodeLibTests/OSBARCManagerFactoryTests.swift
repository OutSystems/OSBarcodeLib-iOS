import XCTest
@testable import OSBarcodeLib

final class OSBARCManagerFactoryTests: XCTestCase {
    func testManagerCreationWithFactoryMethod() {
        let viewController = UIViewController()
        let manager = OSBARCManagerFactory.createManager(with: viewController)
        XCTAssertTrue(manager as? OSBARCManager != nil)
    }
}
