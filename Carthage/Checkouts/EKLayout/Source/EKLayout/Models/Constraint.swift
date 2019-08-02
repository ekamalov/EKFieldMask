//  MIT License
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
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
public struct Constraint {

    public let newView:Layoutable
    
    public let relativeView:Layoutable?
    
    public let newViewAttribute: EKLayoutAttribute
    
    public let relativeViewAttribute: EKLayoutAttribute?
    
    public var value: CGFloat
    
    public let relation: EKLayoutRelation
    
    // MARK: - Initializers
    public init(newView nView: Layoutable,newViewAttribute nAttribute: EKLayoutAttribute,
                relativeView relView: Layoutable? = nil, relativeAttribute relAttribute: EKLayoutAttribute? = .notAnAttribute,
                value: CGFloat = 0, relation: EKLayoutRelation = .equal) {
        self.newView = nView
        self.newViewAttribute = nAttribute
        self.relativeView = relView
        self.relativeViewAttribute = relAttribute
        self.value = value
        self.relation = relation
    }
}

extension Constraint:Hashable {
    public static func == (lhs: Constraint, rhs: Constraint) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(relation)
        hasher.combine(newViewAttribute)
    }
}

