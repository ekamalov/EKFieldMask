//
//  Extensions.swift
//  Example
//
//  Created by Erik Kamalov on 6/28/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views:UIView...){
        views.forEach { addSubview($0) }
    }
}
