//
//  ViewController.swift
//  Example
//
//  Created by Erik Kamalov on 6/26/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit
import EKLayout

class Authorization: UIViewController {
    private lazy var logo = UIImageView(image: #imageLiteral(resourceName: "logo"))
    private lazy var wrapperView = AuthorizationWrapperView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.contentMode = .scaleAspectFill
        
        self.view.addSubviews(wrapperView,logo)
        self.view.backgroundColor = .black
        
        wrapperView.layout { $0.left.right.margin(6.7%).height(260).centerY() }
        logo.layout { $0.bottom(of: wrapperView, aligned: .top, 20, relation: .equal).size(width: 250, height: 150).centerX() }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
  
    @objc func adjustForKeyboard(notification: Notification) {
        if wrapperView.textField.isEditing {
            if notification.name == UIResponder.keyboardWillHideNotification {
                self.wrapperView.transform = .identity
                self.logo.transform = .identity
            } else {
                self.logo.transform = .init(translationX: 0, y: -35)
                self.wrapperView.transform = .init(translationX: 0, y: -60)
            }
        }
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
