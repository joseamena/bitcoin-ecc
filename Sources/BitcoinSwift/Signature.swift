//
//  Signature.swift
//  
//
//  Created by Jose Mena on 9/11/24.
//

import BigInt
import Foundation

public class Signature {
    public let r: BInt
    public let s: BInt
    
    public init(r: BInt, s: BInt) {
        self.r = r
        self.s = s
    }
    
    public func der() -> [UInt8] {
        var rbin = r.asMagnitudeBytes()

        if rbin[0] & 0x80 != 0 {
            rbin = [0] + rbin
        }
        
        var result: [UInt8] = [2, UInt8(rbin.count)] + rbin
        
        var sbin = s.asMagnitudeBytes()
        
        if sbin[0] & 0x80 != 0 {
            sbin = [0] + sbin
        }
        
        result = result + [2, UInt8(sbin.count)] + sbin
        
        return [0x30, UInt8(result.count)] + result
    }
}

extension Signature: CustomStringConvertible {
    public var description: String {
        "Signature(\(r), \(s)"
    }
}
