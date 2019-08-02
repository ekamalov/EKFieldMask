//
//  EKFormatterThrows.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 6/26/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import Foundation

public enum EKFormatterThrows:Error {
    case maskDoNotMatchTemplate
    case canNotFindEditableNode(description:String)
    case invalidCharacter(character:Character)
    
    var localizedDescription: String {
        switch self {
        case .canNotFindEditableNode(description: let description): return "Can't find an editable node. \(description)"
        case .maskDoNotMatchTemplate: return "Mask and pattern are not equal. PS: you can use a character length of one or equal to the pattern \n Example: pattern: ({dddd})-({dddd}) mask: D -> equal (DDDD)-(DDDD) or \n pattern: ({dddd})-({dddd}) mask: (AAAA)-(AAAA) -> equal (AAAA)-(AAAA)"
        case .invalidCharacter(character: let character): return "Invalied character \(character), check current character to pattern"
        }
    }
}
