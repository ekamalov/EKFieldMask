//
//  EKFieldCharacter.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 6/26/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

public enum EKFieldPatternRex: Character {
    case numberDecimal = "d"
    case nonDecimal    = "D"
    case nonWord       = "W"
    case alphabet      = "a"
    case anyChar       = "."
    var rexValue: String {
        switch self {
        case .numberDecimal   : return "\\d"
        case .nonDecimal      : return "\\D"
        case .nonWord         : return "\\W"
        case .alphabet        : return "[a-zA-Z]"
        default              : return "."
        }
    }
}

final class EKFieldCharacter {
    public var isEditable: Bool
    public var value: Character?
    /// The mask template string that represent current block.
    public var patternRex: EKFieldPatternRex
    /// The mask pattern that represent current block.
    public var mask: Character
    
    public init(isEditable: Bool, value: Character? = nil, pattern: EKFieldPatternRex?, mask: Character) {
        self.isEditable = isEditable
        self.value = value
        self.patternRex = pattern ?? .anyChar
        self.mask = mask
    }
}

extension EKFieldCharacter: CustomStringConvertible {
    var description: String {
        return "isPatternEditable:\(isEditable), value:\(String(describing: value)), patternRex:\(patternRex), mask:\(mask)"
    }
}






