//
//  File.swift
//  
//
//  Created by Jose Mena on 9/11/24.
//

import Foundation

extension Array where Element == Byte {
    
    var base58Alphabet: [String] {
        let alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
        return alpha.map { String($0) }
    }
    
    public var data: Data {
        Data(self)
    }
    
    public var hexString: String {
        self.data.hexEncodedString()
    }
    
    public var base58: String {
        var count = 0
        
        for c in self {
            if c == 0 {
                count += 1
            } else {
                break
            }
        }
        
        var num = BInt(magnitude: self)
        var mod = 0
        
        let prefix = String(repeating: "1", count: count)
        
        var result = ""
        while num > 0 {
            (num, mod) = num.quotientAndRemainder(dividingBy: 58)
            result = base58Alphabet[mod] + result
        }
        return prefix + result
    }
}
