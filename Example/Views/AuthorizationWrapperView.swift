//
//  AuthorizationWrapper.swift
//  Example
//
//  Created by Erik Kamalov on 6/27/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit
import EKLayout

class AuthorizationWrapperView: UIView {
    lazy var title:UILabel = .build {
        $0.text = "Sign up"
        $0.font = Fonts.GilroyBold.withSize(25)
        $0.textColor = Colors.authWrapperTitle.value
    }
    lazy var forgotBT:UIButton = .build {
        $0.setTitle("Forgot password ?",for: .normal)
        $0.titleLabel?.font = Fonts.GilroySemiBold.withSize(16)
        $0.setTitleColor(Colors.forgot.value, for: .normal)
    }
    lazy var nextBT:UIButton = .build {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = Colors.nextButton.value
        $0.setImage(UIImage(named: "next-icon"), for: .normal)
    }
    
    lazy var textField:EKFieldMask = .build {
        $0.font = Fonts.GilroySemiBold.withSize(18)
        $0.placeholder = "E-mail or phone number"
    }
    
    var formatter:EKMaskFormatter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.addSubviews(title,forgotBT,nextBT,textField)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.title.layout { $0.left.top.margin(25).height(32).width(50%) }
        self.forgotBT.layout { $0.bottom(of: self, aligned: .bottom, 25, relation: .equal).centerX().size(width: 42.2%, height: 7.1%) }
        self.nextBT.layout { $0.bottom(of: forgotBT, aligned: .top, 15, relation: .equal).centerX().size(width: 84.6%, height: 22.3%) }
        self.textField.layout { $0.top(of: title, aligned: .bottom, 15, relation: .equal).centerX().size(width: 84.6%, height: 23.8%) }
    }
}


