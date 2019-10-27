//
//  AuthorizationWrapper.swift
//  Example
//
//  Created by Erik Kamalov on 6/27/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit
import EKLayout
import EKFieldMask
import EKBuilder

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
        $0.backgroundColor = Colors.nextButton.withAlpha(0.8)
        $0.setImage(UIImage(named: "next-icon"), for: .normal)
        $0.addTarget(self, action: #selector(nextBTAction), for: .touchUpInside)
    }
    
    
    lazy var maskTextField:EKFieldMask = {
        let field = EKFieldMask(placeholder: "E-mail or phone number")
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.addSubviews(title,forgotBT,nextBT,maskTextField)
        maskTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func nextBTAction(){
        self.endEditing(true)
    }
    
    @objc func textChanged(){
        UIView.animate(withDuration: 0.2) {
            self.nextBT.backgroundColor = (self.maskTextField.text?.count ?? 0) == 0 ? Colors.nextButton.withAlpha(0.8) : Colors.nextButton.value
        }
    }
    
    override func layoutSubviews() {
        self.title.layout { $0.left.top.margin(25).height(32).width(50%) }
        self.forgotBT.layout { $0.bottom(of: self, 25, aligned: .bottom).centerX().size(width: 42.2%, height: 7.1%) }
        self.nextBT.layout { $0.bottom(of: forgotBT, 15, aligned: .top).centerX().size(width: 84.6%, height: 22.3%) }
        self.maskTextField.layout { $0.top(of: title, 15, aligned: .bottom).centerX().size(width: 84.6%, height: 23.8%) }
    }
}


