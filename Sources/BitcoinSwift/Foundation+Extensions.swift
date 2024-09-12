//
//  File.swift
//  
//
//  Created by Jose Mena on 9/11/24.
//

import Foundation
import BigInt
import RIPEMD160
import CryptoKit

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
    
    var base58Checksum: String {
        let hash = SHA256.hash(data: self.data).withUnsafeBytes { pointer in
            return Array<UInt8>(pointer)
        }
        
        let hash2 = SHA256.hash(data: hash.data).withUnsafeBytes { pointer in
            return Array<UInt8>(pointer)
        }
        
        let slice = hash2[0...3]
        print("JM", "4 bytes checksum: ", Array(slice).hexString)
        print("JM", "data + checksum: ", (self + slice).hexString)
        return (self + slice).base58
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    func ripemd160() -> Data {
        RIPEMD160.hash(data: self)
    }
    
    func hash160() -> Data {
        print("JM", "data to hash", self.hexEncodedString())
        let hash = SHA256.hash(data: self).withUnsafeBytes { pointer in
            return Array<UInt8>(pointer)
        }
//        guard let round1 = SHA256.hash(data: self).description.data(using: .utf8) else {
//            return Data()
//        }
        
        print("JM", "sha256:", hash.data.hexEncodedString())
//        guard let round2 = SHA256.hash(data: round1).description.data(using: .utf8) else {
//            return Data()
//        }
        print("JM", "hash160:", hash.data.ripemd160().hexEncodedString())
        return hash.data.ripemd160()
    }
}
