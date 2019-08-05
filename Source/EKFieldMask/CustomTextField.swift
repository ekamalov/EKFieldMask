//
//  CustomTextField.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 7/15/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

open class CustomTextField: UITextField {
    internal var appearance:EKTextFieldAppearance! {
        didSet {
            layer.cornerRadius = appearance.cornerRadius
            layer.masksToBounds = appearance.cornerRadius > 0
            layer.borderWidth = appearance.borderWidth
            layer.borderColor = appearance.borderColor.cgColor
            font = appearance.font
            textColor = appearance.textColor
            tintColor = appearance.tintColor
        }
    }
    
    // MARK: - Life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        autocorrectionType = .no
        self.configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    public func setAppearance(appearance: EKTextFieldAppearance) {
        self.appearance = appearance
    }
    
    internal func configure(){
        self.setAppearance(appearance: .init())
    }
    
   public func setLeftImage(image:UIImage) {
        leftViewMode = .always
        leftView = sideImageViewConfigurator(image: image, frame: .init(origin: .zero, size: leftViewRect(forBounds: self.bounds).size),selector: #selector(leftButtonTap))
    }
    public func setClearButtonImage(image:UIImage) {
        rightViewMode = .whileEditing
        rightView = sideImageViewConfigurator(image: image, frame: .init(origin: .zero, size: leftViewRect(forBounds: self.bounds).size), selector: #selector(clearButtonTap))
    }
    
    @objc func leftButtonTap(){}
    @objc func clearButtonTap(){}
    
    internal func sideImageViewConfigurator(image:UIImage,frame:CGRect, selector: Selector) -> UIImageView {
        let img = UIImageView(frame: frame)
        img.image = image
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        img.addGestureRecognizer(tapGestureRecognizer)
        return img
    }
   
    @objc open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: 15, y: (bounds.height - 27) / 2 , width: 27, height: 27)
    }
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: bounds.maxX - 35, y: (bounds.height - 20) / 2 , width: 20, height: 20)
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: (leftView?.frame.maxX ?? 12) + 8 , dy: 5)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: (leftView?.frame.maxX ?? 12) + 8 , dy: 5)
    }
}
