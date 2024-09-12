//
//  ExtensionsTests.swift
//
//
//  Created by Jose Mena on 9/11/24.
//

import BigInt
import XCTest
import Accelerate
@testable import BitcoinSwift

final class ExtensionsTests: XCTestCase {
    func testBase58Conversion() throws {
        let bytes = BInt("7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d", radix: 16)!.asMagnitudeBytes()
        
        XCTAssert("9MA8fRQrT4u8Zj8ZRd6MAiiyaxb2Y1CMpvVkHQu5hVM6" == bytes.base58)
    }
    
    func testHash160() throws {
        let bytes = BInt(5).asMagnitudeBytes()
        print(bytes.data.hash160())
    }
}

