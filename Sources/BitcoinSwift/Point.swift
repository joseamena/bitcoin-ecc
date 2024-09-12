//
//  Point.swift
//
//
//  Created by Jose Mena on 9/8/24.
//

import Foundation
import BigInt

struct Point {
    let x: FieldElement?
    let y: FieldElement?
    let a: FieldElement
    let b: FieldElement
    
    init(x: FieldElement?, y: FieldElement?, a: FieldElement, b: FieldElement) throws {
        self.x = x
        self.y = y
        self.a = a
        self.b = b
        
        guard let x, let y else {
            return
        }
        if y.pow(2) != x.pow(3) + a * x + b {
            throw ECCError.invalidPoint
        }
    }
    
    static func == (left: Point, right: Point) -> Bool {
        return left.a == right.a &&
        left.b == right.b &&
        left.x == right.x &&
        left.y == right.y
    }
    
    static func + (left: Point, right: Point) throws -> Point {
        if left.a != right.a || left.b != right.b {
            throw ECCError.differentCurves
        }
        
        guard let leftX = left.x, let leftY = left.y else {
            return right
        }
        
        guard let rightX = right.x, let rightY = right.y else {
            return left
        }
       
        if leftX == rightX && leftY != rightY {
            return try Point(x: nil, y: nil, a: left.a, b: left.b)
        }
        
        if left == right {
            if leftY.num != 0 {
                let m = (3 * leftX.pow(2) + left.a) / (2 * leftY)
                let x3 = m.pow(2) - 2 * leftX
                let y3 = m * (leftX - x3) - leftY
                return try Point(x: x3, y: y3, a: left.a, b: left.b)
            } else {
                return try Point(x: nil, y: nil, a: left.a, b: left.b)
            }
        }
        
        let m = (rightY - leftY) / (rightX - leftX)
        let x3 = m.pow(2) - leftX - rightX
        let y3 = m * (leftX - x3) - leftY
        return try Point(x: x3, y: y3, a: left.a, b: left.b)
    }
    
    static func * (left: Point, coefficient: BInt) throws -> Point {
        var coef = coefficient
        var current = left
        var result = try Point(x: nil, y: nil, a: left.a, b: left.b)
        while coef != 0 {
            if coef & BInt.ONE != 0 {
                result = try result + current
            }
            current = try current + current
            coef >>= 1
        }
        return result
    }
    
}

extension Point: CustomStringConvertible {
    var description: String {
        if let xNum = x?.num, let yNum = y?.num {
            return "x: \(xNum), y: \(yNum), a: \(a.num), b: \(b.num)"
        }
        return "infinity, a: \(a.num), b: \(b.num)"
    }
}
