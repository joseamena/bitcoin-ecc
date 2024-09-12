//
//  PointTests.swift
//
//
//  Created by Jose Mena on 9/8/24.
//

import XCTest
import BigInt

@testable import BitcoinSwift

final class PointTests: XCTestCase {

    func testOnCurve() throws {
        let prime = 223
        let a = FieldElement(0, 223)
        let b = FieldElement(7, 223)
        
        let validPoints: [(Int, Int)] = [
            (192, 105),
            (17, 56),
            (1, 193)
        ]
        
        for (xRaw, yRaw) in validPoints {
            let x = FieldElement(xRaw, prime)
            let y = FieldElement(yRaw, prime)
            let point = try? Point(x: x, y: y, a: a, b: b)
            XCTAssert(point != nil)
        }
    }
    
    func testNotOnCurve() throws {
        let prime = 223
        let a = FieldElement(0, prime)
        let b = FieldElement(7, prime)
        
        let invalidPoints: [(Int, Int)] = [
            (200, 119),
            (42, 99)
        ]
        
        for (xRaw, yRaw) in invalidPoints {
            let x = FieldElement(xRaw, prime)
            let y = FieldElement(yRaw, prime)
            let point = try? Point(x: x, y: y, a: a, b: b)
            XCTAssert(point == nil)
        }
    }
    
    func testAdditionToItself() throws {
        let prime = 223
        let a = FieldElement(0, prime)
        let b = FieldElement(7, prime)
        let x = FieldElement(192, prime)
        let y = FieldElement(105, prime)
        
        let point = try? Point(x: x, y: y, a: a, b: b)
        guard let point else {
            XCTFail("Point is not in curve")
            return
        }
        let result = try Point(x: FieldElement(49, prime), y: FieldElement(71, prime), a: a, b: b)
        
        let point2 = try point + point
        XCTAssert(point2 == result)
    }
    
    func testS256PointCreationInCurve() throws {
        let x = BInt("68457667689099005220875649582852652559185904178139380821442886811333032234798", radix: 10)!
        let y = BInt("17017700180730250594611479824176566765086657220117403812749246357277370236975", radix: 10)!
        
        let point = try? S256Point(x: x, y: y)
        XCTAssert(point != nil)
    }
    
    func testS256PointCreationNotInCurve() throws {
        let point = try? S256Point(x: .EIGHT, y: .FIVE)
        XCTAssert(point == nil)
    }
    
    
    func testGPointisOfOrderN() throws {
        let point = S256Point.G!
        let n = S256Point.N
        
        let res = try point * n
        let infinity = try S256Point(x: nil, y: nil)
        XCTAssert(res == infinity)
    }
    
    func testSerialization() throws {
        let x = BInt("68457667689099005220875649582852652559185904178139380821442886811333032234798", radix: 10)!
        let y = BInt("17017700180730250594611479824176566765086657220117403812749246357277370236975", radix: 10)!
        
        let point = try S256Point(x: x, y: y)
        
        print(point.sec().hexString)
    }
}
