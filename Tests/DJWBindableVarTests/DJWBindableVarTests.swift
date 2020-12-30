import XCTest
@testable import DJWBindableVar

final class DJWBindableVarTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DJWBindableVar().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
    
    
    
    func testBBind(){
        
        let audio:BVar<Double?> = BVar(nil)
        let mixer:BVar<Double?> = BVar(nil)
        
        var ui:Double?
        var player:Double?
        
        mixer.value = 75.50
        
        mixer.bind(.ui, andSet: true) { value in
            ui = value
        }
        audio.bind(.audio, andSet: true) { value in
            player = value
        }
        
        // bbind
        mixer.bBind(.slave, andSet: true, to: audio)
        

        
        XCTAssertEqual(mixer.value, audio.value)
        
        XCTAssertEqual(ui, player)

        XCTAssertTrue(mixer.bondBranches.contains(.slave))
        XCTAssertTrue(mixer.bondBranches.contains(.ui))
        
        XCTAssertTrue(audio.bondBranches.contains(.master))
        XCTAssertTrue(audio.bondBranches.contains(.audio))
        
        audio.value = 45.33
        
        XCTAssertEqual(ui, player)
        
        print(mixer.bondConnections)
        
        print(audio.bondConnections)
        
        audio.unbind(.audio)
        
        audio.value = 25.54
        
        XCTAssertNotEqual(ui, player)
        
        
    }
}
