//
//  SCNVector3+Extensions.swift
//  Ruler
//
//  Created by Kryg Tomasz on 07.09.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation
import ARKit

extension SCNVector3 {
    
    func distance(from vector: SCNVector3) -> Float {
        let xDistance = self.x - vector.x
        let yDistance = self.y - vector.y
        let zDistance = self.z - vector.z
        
        return sqrt((xDistance * xDistance) + (yDistance * yDistance) + (zDistance * zDistance))
    }
    
}

extension SCNVector3: Equatable {
    
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
    
}
