//
//  S256Point.swift
//
//
//  Created by Jose Mena on 9/10/24.
//

import Foundation
import BigInt

public struct S256Point {

    public static let A = 0
    public static let B = 7
    public static let N = BInt("fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141", radix: 16)!
    public static let G: S256Point!  = try? S256Point(
        x: BInt("79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798", radix: 16)!,
        y: BInt("483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8", radix: 16)!
    )
    
    let point: Point
    
    public init(x: BInt?, y: BInt?) throws {
        let a = S256Field(num: S256Point.A)
        let b = S256Field(num: S256Point.B)
        var x256: S256Field?
        var y256: S256Field?
        if let x {
            x256 = S256Field(num: x)
        }
        
        if let y {
            y256 = S256Field(num: y)
        }
        
        point = try Point(x: x256?.field, y: y256?.field, a: a.field, b: b.field)
    }
    
    init(point: Point) {
        self.point = point
    }
    
    var x: S256Field? {
        guard let field = point.x else {
            return nil
        }
        return S256Field(field: field)
    }
    
    var y: S256Field? {
        guard let field = point.y else {
            return nil
        }
        return S256Field(field: field)
    }
    
    public func verify(message: BInt, signature: Signature) -> Bool {
        let sInv = signature.s.expMod(S256Point.N - 2, S256Point.N)
        let u = (message * sInv) % S256Point.N
        let v = (signature.r * sInv) % S256Point.N
        guard let temp1 = try? (S256Point.G * u) else {
            return false
        }
        guard let temp2 = try? self * v else {
            return false
        }
        guard let total = try? temp1 + temp2 else {
            return false
        }
        
        return total.point.x?.num == signature.r
    }
    
    public func sec(compressed: Bool = true) -> Bytes {
        guard let xBytes = point.x?.num.asMagnitudeBytes(), let yBytes = point.y?.num.asMagnitudeBytes() else {
            return []
        }
        
        let xPadding = 32 - xBytes.count
        let yPadding = 32 - xBytes.count
        
        guard xPadding >= 0, yPadding >= 0 else {
            return []
        }
        
        let paddedX = Array<Byte>.init(repeating: 0, count: xPadding) + xBytes
        let paddedY = Array<Byte>.init(repeating: 0, count: yPadding) + yBytes
        
        if compressed {
            if (yBytes.last ?? 0) % 2 == 0 {
                return [2] + paddedX
            } else {
                return [3] + paddedX
            }
        }
        
        return [4] + paddedX + paddedY
    }
}

public extension S256Point {
    static func == (left: S256Point, right: S256Point) -> Bool {
        left.point == right.point
    }
    
    static func + (left: S256Point, right: S256Point) throws -> S256Point {
        S256Point(point: try left.point + right.point)
    }
    
    static func * (left: S256Point, coefficient: BInt) throws -> S256Point {
        S256Point(point: try left.point * coefficient)
    }
}



public extension S256Point {
    
    enum Network {
        case mainNet
        case testNet
        case regTest
    }
    
   func hash160(compressed: Bool = true) -> Data {
       let sec = sec(compressed: compressed).data
       print("JM", "sec", "\(compressed ? "yes" : "no")", sec.hexEncodedString())
       return sec.hash160()
    }
    
    func address(compressed: Bool = true, network: Network) -> String {
        let hash160 = hash160(compressed: compressed)
        
        print("JM", "hash160", hash160.hexEncodedString())
        let prefix: UInt8
        
        switch network {
            
        case .mainNet:
            prefix = 0x00
        case .testNet:
            prefix = 0x6f
        case .regTest:
            prefix = 0x6f
        }
        
        return ([prefix] + hash160).base58Checksum
    }
}
