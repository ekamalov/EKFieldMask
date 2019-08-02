//
//  EKMaskFormatter+Extension.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 7/8/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

extension Character {
    func matches(_ pattern:String)-> Bool {
        let selfString = String(self)
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let range = NSRange(location: 0, length: selfString.utf16.count)
        return regex.firstMatch(in: selfString, options: [], range: range) != nil
    }
}

internal extension Array where Element:EKFieldCharacter {
    func nextEditableElement(index:Int, checker: @escaping ((Element) -> Bool)) -> (index:Int,value:Element)? {
        var index = index
        while index < self.count {
            let element = self[index]
            if checker(element)  {
                return (index: index, value: element)
            }
            index += 1
        }
        return nil
    }
    
    func previousEditableElement(index:Int? = nil) -> (index:Int,value:Element)? {
        var index = (index ?? self.count)
        while index > 0 {
            let element = self[index]
            if element.isEditable && element.value != nil {
                return (index: index, value: element)
            }
            index -= 1
        }
        return nil
    }
}

internal extension Array where Element: EKFieldCharacter {
    var asText:String {
        var str = ""
        self.forEach { str += String($0.value != nil ? $0.value! : $0.mask) }
        return str
    }
}

