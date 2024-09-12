//
//  PrivateKey.swift
//
//
//  Created by Jose Mena on 9/11/24.
//

import BigInt
import Foundation

public class PrivateKey {
    let secret: BInt
    let point: Point?
    
    public init(secret: BInt) {
        self.secret = secret
        self.point = try? S256Point.G.point * secret
    }
    
    public func sign(message: BInt) -> Signature? {
        let r = try? (S256Point.G.point * k).x?.num
        let kInv = k.expMod(S256Point.N - 2, S256Point.N)
        guard let r else {
            return nil
        }
        var s = (message + (secret * r)) * kInv % S256Point.N
        if s > S256Point.N / 2 {
            s = S256Point.N - s
        }
        return Signature(r: r, s: s)
    }
    
    private var k: BInt {
        BInt(bitWidth: 256)
    }
}
