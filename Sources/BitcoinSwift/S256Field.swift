//
//  S256Field.swift
//
//
//  Created by Jose Mena on 9/8/24.
//

import Foundation
import BigInt

public struct S256Field {
    // P = 2**256 - 2**32 - 977
    static private let P: BInt = (BInt(2) ** 256) - (BInt(2) ** 32) - 977
    
    let field: FieldElement
    
    public init(num: Int) {
        field = FieldElement(BInt(num), S256Field.P)
    }
    
    public init(num: BInt) {
        field = FieldElement(num, S256Field.P)
    }
    
    var num: BInt {
        field.num
    }
    
    public init(field: FieldElement) {
        self.field = field
    }

    public func sqrt() -> S256Field {
        let a = self.field.num.expMod((S256Field.P + 1) / 4, S256Field.P)
        return S256Field(num: a)
    }
}

extension S256Field {
    static func + (left: S256Field, right: S256Field) -> S256Field {
        S256Field(field: left.field + right.field)
    }
    
    static func - (left: S256Field, right: S256Field) -> S256Field {
        S256Field(field: left.field - right.field)
    }
    
    static func * (left: S256Field, right: S256Field) -> S256Field {
        S256Field(field: left.field * right.field)
    }
    
    static func * (left: S256Field, right: Int) -> S256Field {
        S256Field(field: left.field * right)
    }
    
    static func * (left: Int, right: S256Field) -> S256Field {
        S256Field(field: left * right.field)
    }
    
    static func / (left: S256Field, right: S256Field) -> S256Field {
        S256Field(field: left.field / right.field)
    }
    
    func pow (_ exponent: S256Field ) -> S256Field {
        S256Field(field: field.pow(exponent.field))
    }
    
    func pow (_ exponent: Int ) -> S256Field {
        S256Field(field: field.pow(exponent))
    }
}
