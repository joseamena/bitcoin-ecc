import XCTest
import Accelerate
@testable import BitcoinSwift

final class BitcoinSwiftTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testFieldElementAdd() throws {
        let element1 = FieldElement(18, 19)
        let element2 = FieldElement(3, 19)
        let element3 = FieldElement(2, 19)
  
        print(element1 + element2)
        print(element3)
        XCTAssert((element1 + element2) == element3)
    }

    func testFieldElementSubtract() throws {
        let element1 = FieldElement(3, 19)
        let element2 = FieldElement(2, 19)
        let element3 = FieldElement(18, 19)
                
        XCTAssert((element2 - element1) == element3)
    }
    
    func testFieldElementMultiply() throws {
        let a = FieldElement(3, 13)
        let b = FieldElement(12, 13)
        let c = FieldElement(10, 13)
                
        XCTAssert(a * b == c)
    }
    
    func testFieldElementDivide() throws {
        let a = FieldElement(3, 31)
        let b = FieldElement(24, 31)
        
        XCTAssert(a / b == FieldElement(4, 31))
    }
    
    func testFieldElementPowPositive() throws {
        let a = FieldElement(3, 13)
        let b = FieldElement(12, 13)
        let c = FieldElement(1, 13)
                
        XCTAssert(a.pow(b) == c)
    }
    
    func testFieldElementPowNegative() throws {
        let a = FieldElement(17, 31)
        let b = FieldElement(-4, 31)
        let c = FieldElement(29, 31)
 
        XCTAssert(a.pow(b) == c)
    }
}
