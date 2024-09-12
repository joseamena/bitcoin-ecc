//
//  SignatureTests.swift
//
//
//  Created by Jose Mena on 9/11/24.
//

import Foundation
import XCTest
import BigInt

@testable import BitcoinSwift

final class SignatureTests: XCTestCase {
    func testDer() throws {
        let r = BInt("37206a0610995c58074999cb9767b87af4c4978db68c06e8e6e81d282047a7c6", radix: 16)!
        let s = BInt("8ca63759c1157ebeaec0d03cecca119fc9a75bf8e6d0fa65c841c8e2738cdaec", radix: 16)!
        
        let sig = Signature(r: r, s: s)
        print(sig.der().hexString)
    }
}
