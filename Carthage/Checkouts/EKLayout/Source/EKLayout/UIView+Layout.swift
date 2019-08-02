//
//  UIView+Layout.swift
//  EKKit
//
//  Created by Erik Kamalov on 4/14/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

extension EKLayoutableView:Layoutable {
    public func layout(_ closure: EKLayoutBuilderClosure)  {
        EKLayout.activateLayout(view: self, closure: closure)
    }
}
