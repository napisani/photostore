import XCTest
import Capacitor
@testable import Plugin

class PluginTests: XCTestCase {

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEcho() {
        // This is an example of a functional test case for a plugin.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // when system alert is shown -> dismiss it by pressing "OK"
          // (the description parameter is only there for debugging purposes
          // so it can be anything you like)
//          addUIInterruptionMonitor(withDescription: "Photos Access Alert") { (alert) -> Bool in
//              alert.buttons["OK"].tap()
//              return true
//          }

        let value = 0
        let plugin = PhotoLibrary()
        print("beginning test")

        let call = CAPPluginCall(callbackId: "test", options: [
            "mode": "fast"
        ], success: { (result, _) in
            let resultValue = result!.data["total"] as? Int
            XCTAssertEqual(value, resultValue)
            print("in success!")
        }, error: { (err: Optional<CAPPluginCallError>) in
//            print(Thread.callStackSymbols)

            print("inside error!!! \(err!)")
            XCTFail("Error shouldn't have been called")
        })

        plugin.getPhotos(call!)
    }
}
