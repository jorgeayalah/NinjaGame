//
//  File.swift
//  NinjaGame
//
//  Created by Alumno on 25/11/21.
//

import CoreGraphics

extension CGFloat{
    static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF)) // returns 0 or 1
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat{
        assert(min < max)
        return CGFloat.random() * (max-min) + min // return min or max
    }
}
