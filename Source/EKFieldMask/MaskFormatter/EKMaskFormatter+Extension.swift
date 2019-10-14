//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Erik Kamalov <ekamalov967@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

internal extension UITextField {
    func moveCaret(to position:Int) {
        guard let caretPosition = self.position(from: self.beginningOfDocument, offset: position) else {
            return
        }
        self.selectedTextRange = self.textRange(from: caretPosition, to: caretPosition)
    }
}

internal extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}


