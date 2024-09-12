//
//  FieldElement.swift
//
//
//  Created by Jose Mena on 9/3/24.
//
import BigInt
import Foundation

public struct FieldElement {
    let num: BInt
    let prime: BInt
    
    public init(_ num: Int, _ prime: Int) {
        if num < 0 {
            self.num = BInt(((num % prime) + prime) % prime)
        } else {
            self.num = BInt(num)
        }
        self.prime = BInt(prime)
    }
    
    public init(_ num: BInt, _ prime: BInt) {
        if num < 0 {
            self.num = ((num % prime) + prime) % prime
        } else {
            self.num = num
        }
        self.prime = prime
    }
    
    public init(_ hexNum: String, _ hexPrime: String) {
        self.num = BInt(hexNum, radix: 16) ?? BInt(0)
        self.prime = BInt(hexPrime, radix: 16) ?? BInt(1)
    }
}

extension FieldElement: Equatable {
    public static func == (lhs: FieldElement, rhs: FieldElement) -> Bool {
        return lhs.num == rhs.num && lhs.prime == rhs.prime
    }
}

extension FieldElement: CustomStringConvertible {
    public var description: String {
        "FieldElement_\(prime)(\(num))"
    }
}

extension FieldElement {
    static func + (left: FieldElement, right: FieldElement) -> FieldElement {
        return FieldElement((left.num + right.num) % left.prime, left.prime)
    }
    
    static func - (left: FieldElement, right: FieldElement) -> FieldElement {
        let substraction = left.num - right.num
        let mod = ((substraction % left.prime) + left.prime) % left.prime
        return FieldElement(mod, left.prime)
    }
    
    static func * (left: FieldElement, right: FieldElement) -> FieldElement {
        return FieldElement((left.num * right.num) % left.prime, left.prime)
    }
    
    static func * (left: FieldElement, right: Int) -> FieldElement {
        return FieldElement((left.num * right) % left.prime, left.prime)
    }
    
    static func * (left: Int, right: FieldElement) -> FieldElement {
        return FieldElement((left * right.num) % right.prime, right.prime)
    }
    
    static func / (left: FieldElement, right: FieldElement) -> FieldElement {
        let num = (left.num * right.num.expMod(left.prime -  2, left.prime)).mod(left.prime)
        return FieldElement(num, left.prime)
    }
    
    func pow (_ exponent: FieldElement ) -> FieldElement {
        let primer = self.prime - 1
        let n = ((exponent.num % primer) + primer) % primer
        let num = self.num.expMod(n, self.prime)
        return FieldElement(num, self.prime)
    }
    
    func pow (_ exponent: Int ) -> FieldElement {
        let primer = self.prime - 1
        let n = ((exponent % primer) + primer) % primer
        let num = self.num.expMod(n, self.prime)
        return FieldElement(num, self.prime)
    }
    
    
}

enum ECCError: Error {
    case valueError
    case differentCurves
    case invalidPoint
}
