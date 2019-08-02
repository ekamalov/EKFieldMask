//
//  ViewController.swift
//  Example
//
//  Created by Erik Kamalov on 4/17/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit
 
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let v = UIView.init(frame: .init(x: 20, y: 200, width: 100, height: 100))
        v.backgroundColor = .red
        
        let v1 = UIView()
        v1.backgroundColor = .green
        
        
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(v)
            self.view.addSubview(v1)
        }, completion: nil)
        
        
        //        v.layout { view in
        //            view.size(width: 100, height: 100)
        //            view.centerX(20).top(100)
        //        }
        
        //        v1.layout { $0.left.right.margin(6.7%).height(33.1%).centerY() }
        
//        v.layout {
//            $0.size(200).right(20%).bottom(20)
//        }
        
        print(v1.frame)
        print(v.frame)
    }
    
    
}

