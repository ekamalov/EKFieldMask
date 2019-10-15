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
        // overrideUserInterfaceStyle is available with iOS 13
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        logo.contentMode = .scaleAspectFill
        
        self.view.addSubviews(wrapperView, logo)
        self.view.backgroundColor = .black
        
        wrapperView.layout { $0.left.right.margin(6.7%).height(260).centerY() }
        logo.layout { $0.bottom(of: wrapperView, 20, aligned: .top).size(width: 250, height: 150).centerX() }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if wrapperView.maskTextField.isEditing {
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
