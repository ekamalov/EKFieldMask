//
//  The MIT License (MIT)
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
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

open class CustomTextField: UITextField{
    // MARK: - Properties
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
        self.configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    // MARK: - Set up
    public func setAppearance(appearance: EKTextFieldAppearance) {
        self.appearance = appearance
    }
    internal func configure(){
        autocorrectionType = .no
        addTarget(self, action: #selector(textChanged), for: .editingChanged)
        self.setAppearance(appearance: .init())
    }
    public func setLeftImage(image:UIImage) {
        leftViewMode = .always
        leftView = sideImageViewConfigurator(image: image, frame: .init(origin: .zero, size: leftViewRect(forBounds: self.bounds).size),selector: #selector(leftButtonTap))
    }
    public func setClearButtonImage(image:UIImage) {
        rightView = sideImageViewConfigurator(image: image, frame: .init(origin: .zero, size: leftViewRect(forBounds: self.bounds).size), selector: #selector(clearButtonTap))
    }
    internal func sideImageViewConfigurator(image:UIImage,frame:CGRect, selector: Selector) -> UIImageView {
        let img = UIImageView(image: image)
        img.frame = frame
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
    // MARK: - Actions
    @objc func textChanged(){
        rightViewMode = (text?.count ?? 0) > 0 ? .always : .never
    }
    @objc func leftButtonTap(){}
    @objc func clearButtonTap(){}
}
