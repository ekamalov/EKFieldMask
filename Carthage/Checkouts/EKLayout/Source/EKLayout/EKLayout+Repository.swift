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

public class Repository {
    private var layout:EKLayout
    private var temporaryConstraint = Set<Constraint>()
    private var prodConstraint = Set<Constraint>()
    
    public init(layout:EKLayout) {
        self.layout = layout
    }
    
    internal func moveTempConstToProdMult(constant value: CGFloat){
        self.temporaryConstraint.forEach { item in
            var const = item
            const.value = item.newViewAttribute == .right || item.newViewAttribute == .bottom ? -value : value
            if prodConstraint.contains(item) {
                self.prodConstraint.update(with: const)
            }
            self.prodConstraint.insert(const)
            self.temporaryConstraint.remove(item)
        }
    }
    
    internal func moveFromTempToProdSingle(constraint item:Constraint) {
        self.addProdConst(constraint: item)
        self.temporaryConstraint.remove(item)
    }
    
    internal func addProdConst(constraint item:Constraint) {
        if self.prodConstraint.contains(item) {
            self.prodConstraint.update(with: item)
        }
        self.prodConstraint.insert(item)
    }
    
    internal func addTempConst(_ attribute:EKLayoutAttribute)  {
        var const:Constraint
        if attribute == .width || attribute == .height {
            const = Constraint(newView: layout.view, newViewAttribute: attribute)
        }else {
            const = Constraint(newView: layout.view, newViewAttribute: attribute, relativeView: layout.view.superview, relativeAttribute: attribute)
        }
        
        if temporaryConstraint.contains(const) {
            self.temporaryConstraint.update(with: const)
        }
        self.temporaryConstraint.insert(const)
    }
    
    internal func getProdConstraint()-> Set<Constraint> {
        return self.prodConstraint
    }
    
    internal func getTempConstraint()-> Set<Constraint> {
        return self.temporaryConstraint
    }
}


