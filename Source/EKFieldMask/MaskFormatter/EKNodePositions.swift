//
//  EKNodePositions.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 7/8/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import Foundation

public struct EKNodePositions {
    var current:Int
    var next:Int?
    init(current:Int, next:Int? = nil) {
        self.current = current
        self.next = next
    }
}
