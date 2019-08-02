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

public final class EKLayout {
    
    internal let view:Layoutable
    internal lazy var repository = Repository(layout: self)
    
    internal init(view:Layoutable){
        self.view = view
        self.view.prepare()
    }
    
    internal static func activateLayout(view:Layoutable,closure:EKLayoutBuilderClosure)  {
        let layt = EKLayout(view: view)
        closure(layt)
        var constraints:[EKLayoutConstraint] = []
        layt.repository.getProdConstraint().forEach { const in
            let tempConst = EKLayoutConstraint(item: const.newView, attribute: const.newViewAttribute,
                                               relatedBy: const.relation, toItem: const.relativeView,
                                               attribute: const.relativeViewAttribute ?? .notAnAttribute, multiplier: 1, constant: const.value)
            constraints.append(tempConst)
        }
        NSLayoutConstraint.activate(constraints)
        #if DEBUG
        print("layout activated")
        #endif
    }
    
}

extension EKLayout {
    internal func addConst(_ attribute: EKLayoutAttribute) -> EKLayout {
        self.repository.addTempConst(attribute)
        return self
    }
    
    @discardableResult
    public func margin(_ value:Value)-> EKLayout {
        guard let percent = value as? Percent else {
            self.repository.moveTempConstToProdMult(constant: value.toCGFloat)
            return self
        }
        
        repository.getTempConstraint().forEach {
            var const:Constraint = $0
            let superViewRect = const.newView.superviewRect
            
            switch const.newViewAttribute {
            case .top, .bottom, .height, .centerY: const.value = percent.of(superViewRect.height)
            case .left, .right, .width, .centerX: const.value = percent.of(superViewRect.width)
            default: break
            }
            
            if const.newViewAttribute == .right || const.newViewAttribute == .bottom {
                const.value = -const.value
            }
            
            self.repository.moveFromTempToProdSingle(constraint: const)
        }
        return self
    }
}

