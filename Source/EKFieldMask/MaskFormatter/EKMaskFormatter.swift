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

import Foundation

public struct EKMaskFormatter {
    // MARK: - Properties
    var pattern: String
    var mask: String
    
    // MARK: - Initializers
    init(pattern: String, mask: String) throws {
        self.pattern = pattern
        self.mask = mask
        try self.configuration()
    }
    
    private var actuallyNode:(index:Int,value:EKFieldCharacter)?
    private var charactersNode:[EKFieldCharacter] = []
    private let maskTemplateDefault: Character = "*" , leftBrackets: Character = "{" , rightBrackets: Character = "}"
    
    // MARK: - Set up
    mutating private func configuration() throws {
        charactersNode.removeAll()
        pattern.filter { $0 != self.leftBrackets && $0 != self.rightBrackets }.enumerated().forEach { index,char in
            let pattern = EKFieldPatternRex(rawValue: char)
            let charc = EKFieldCharacter(isEditable: pattern == nil ? false : true, pattern: pattern, mask: self.maskTemplateDefault)
            charactersNode.append(charc)
        }
        if charactersNode.count != mask.count && mask.count != 1{
            throw EKFormatterThrows.maskDoNotMatchTemplate
        }
        charactersNode.enumerated().forEach { index, item in
            item.mask = charactersNode.count == mask.count ? mask[index] : mask[0]
        }
    }
}
// MARK: - Extensions
public extension EKMaskFormatter {
    mutating func clearMask() {
        self.charactersNode.filter { $0.isEditable }.forEach { _ in
            _ = try? deleteLast()
        }
    }
    mutating func deleteLast() throws -> EKNodePositions {
        return try self.delete(at: actuallyNode?.index ?? self.charactersNode.count - 1)
    }
    
    mutating func delete(at index:Int) throws -> EKNodePositions {
        if let indexNode = charactersNode.previousEditableElement(index: index) {
            indexNode.value.value = nil
            self.actuallyNode = charactersNode.previousEditableElement(index: indexNode.index)
            return EKNodePositions.init(current: indexNode.index, next: self.actuallyNode?.index)
        }
        throw EKFormatterThrows.canNotFindEditableNode(description:"Failed to get the next node or node by index: \(index)")
    }
    
    mutating func insert<S>(contentsOf newCharacters: S, from index:Int? = nil) throws -> EKNodePositions where Character == S.Element, S: Sequence {
        var lastNode:EKNodePositions = .init(current: index ?? actuallyNode?.index ?? 0)
        
        if index == nil, let actNode = actuallyNode, actNode.value.value != nil {
            lastNode.current = charactersNode.nextEditableElement(index: actNode.index, checker: { $0.isEditable && $0.value == nil })?.index ?? 0
        }
        
        for char in newCharacters {
            lastNode = try self.insert(char, at: lastNode.next ?? lastNode.current)
            if lastNode.next == nil, let nextPosition = charactersNode.nextEditableElement(index: lastNode.current, checker: { $0.isEditable })?.index {
                lastNode.next = nextPosition + 1
            }else { continue }
        }
        return lastNode
    }
    
    mutating func insert(_ newCharacter:Character, at i:Int? = nil) throws -> EKNodePositions {
        var tmpNode = actuallyNode
        if let index = i, let nodeByIndex = charactersNode.nextEditableElement(index: index, checker: { $0.isEditable }) {
            tmpNode = nodeByIndex
        }else if tmpNode == nil {
            tmpNode = charactersNode.nextEditableElement(index: 0, checker: { $0.isEditable && $0.value == nil })
        }
        
        guard let actNode = tmpNode else { throw EKFormatterThrows.canNotFindEditableNode(description:"Failed to get the next node or node by index:\(i ?? 0)") }
        guard  newCharacter.matches(actNode.value.patternRex.rexValue) else { throw EKFormatterThrows.invalidCharacter(character: newCharacter) }
        
        actNode.value.value = newCharacter
        self.actuallyNode = charactersNode.nextEditableElement(index: actNode.index, checker: { $0.isEditable && $0.value == nil })
        return EKNodePositions(current: actNode.index, next: self.actuallyNode?.index)
    }
}

public enum EKMaskFormatterStatus {
    case clear, incomplete, complete
}

public extension EKMaskFormatter {
    var text:String { return charactersNode.asText }
    var firstEditableNodeIndex:Int? {
        return self.charactersNode.nextEditableElement(index: 0, checker: { $0.isEditable } )?.index
    }
    var status:EKMaskFormatterStatus {
        let editableNodes = self.charactersNode.filter { $0.isEditable }
        let completeNodes = editableNodes.filter { $0.value != nil }
        switch completeNodes.count {
        case 0:                     return .clear
        case editableNodes.count:   return .complete
        default:                    return .incomplete
        }
    }
}

