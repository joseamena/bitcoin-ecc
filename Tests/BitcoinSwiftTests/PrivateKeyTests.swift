//
//  PrivateKeyTests.swift
//
//
//  Created by Jose Mena on 9/11/24.
//

import Foundation

import XCTest
import BigInt

@testable import BitcoinSwift

final class PrivateKeyTests: XCTestCase {
    
    func testEncoding() throws {
        var key = PrivateKey(secret: BInt(5000))
        var encoded =
        "04ffe558e388852f0120e46af2d1b370f85854a8eb0841811ece0e3e03d282d57c315dc72890a4f10a1481c031b03b351b0dc79901ca18a00cf009dbdb157a1d10"
        
        XCTAssert(key.point?.sec().hexString == encoded)
        
        key = PrivateKey(secret: BInt(2018) ** 5)
        encoded =
        "04027f3da1918455e03c46f659266a1bb5204e959db7364d2f473bdf8f0a13cc9dff87647fd023c13b4a4994f17691895806e1b40b57f4fd22581a4f46851f3b06"
        
        XCTAssert(key.point?.sec().hexString == encoded)
        
        key = PrivateKey(secret: BInt("deadbeef12345", radix: 16)!)
        encoded =
        "04d90cd625ee87dd38656dd95cf79f65f60f7273b67d3096e68bd81e4f5342691f842efa762fd59961d0e99803c61edba8b3e3f7dc3a341836f97733aebf987121"
        
        XCTAssert(key.point?.sec().hexString == encoded)
    }
    
    func testCompressedEncoding() throws {
        var key = PrivateKey(secret: BInt(5001))
        var encoded =
        "0357a4f368868a8a6d572991e484e664810ff14c05c0fa023275251151fe0e53d1"
        
        XCTAssert(key.point?.sec(compressed: true).hexString == encoded)
        
        key = PrivateKey(secret: BInt(2019) ** 5)
        encoded =
        "02933ec2d2b111b92737ec12f1c5d20f3233a0ad21cd8b36d0bca7a0cfa5cb8701"
        
        XCTAssert(key.point?.sec(compressed: true).hexString == encoded)
        
        key = PrivateKey(secret: BInt("deadbeef54321", radix: 16)!)
        encoded =
        "0296be5b1292f6c856b3c5654e886fc13511462059089cdf9c479623bfcbe77690"
        
        XCTAssert(key.point?.sec(compressed: true).hexString == encoded)
    }
    
    func testAddress() throws {
        var priv = PrivateKey(secret: BInt(5002))
        var address = priv.point!.address(compressed: false, network: .testNet)
        XCTAssert(address == "mmTPbXQFxboEtNRkwfh6K51jvdtHLxGeMA")
        
        priv = PrivateKey(secret: BInt(2020) ** 5)
        address = priv.point!.address(compressed: true, network: .testNet)
        XCTAssert(address == "mopVkxp8UhXqRYbCYJsbeE1h1fiF64jcoH")
        
        priv = PrivateKey(secret: BInt("12345deadbeef", radix: 16)!)
        address = priv.point!.address(compressed: true, network: .mainNet)
        XCTAssert(address == "1F1Pn2y6pDb68E5nYJJeba4TLg2U7B6KF1")
    }
}
