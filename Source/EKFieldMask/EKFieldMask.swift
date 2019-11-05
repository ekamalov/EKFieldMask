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

open class EKFieldMask: CustomTextField {
    // MARK: - Properties
    private(set) open var globalPreferences: EKFieldPreferences
    private(set) var tipViewTitle: String
    var formatter:EKMaskFormatter!
    var country:Country? {
        willSet {
            guard let value = newValue else { return }
            setPhoneNumberMask(pattern: value.pattern, mask: value.mask)
        }
    }
    
    var type:EKFieldMaskType = .none {
        willSet {
            switch newValue {
            case .email, .none:
                self.leftView = nil
                self.keyboardType = .emailAddress
            case .phoneNumber:
                self.keyboardType = .phonePad
                if let flagName = country?.cc, let flagImage = UIImage(named: flagName){
                    self.setLeftImage(image: flagImage)
                }
            }
            reloadInputViews()
        }
    }
    
    
    // MARK: - Static variables
    public static var staticGlobalPreferences = EKFieldPreferences()
    
    // MARK: - Enums
    enum FieldEvent {
        case delete,insert
    }
    enum EKFieldMaskType {
        case email,phoneNumber, none
    }
    
    // MARK: - Set up
    public override func setLeftImage(image: UIImage) {
        leftViewMode = .always
        let view = UIView.init(frame: .init(origin: .zero, size: leftViewRect(forBounds: self.bounds).size))
        let img = sideImageViewConfigurator(image: image, frame: .init(origin: .zero, size: view.frame.size),
                                            selector: #selector(leftButtonTap))
        
        img.layer.cornerRadius = img.frame.size.width / 2
        img.clipsToBounds = true
        
        view.layer.applySketchShadow(color: .black, alpha: 0.4, offset: .init(width: 0, height: 1), blur: 8)
        view.addSubview(img)
        leftView = view
    }
    
    // MARK: - Initializers
    internal override init(frame: CGRect) {
        self.globalPreferences = EKFieldMask.staticGlobalPreferences
        self.tipViewTitle = "Tap again to clear"
        super.init(preferences: globalPreferences.textField)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /// Public initializer
    /// - Parameter title: TipView title
    /// - Parameter placeholder: text field placeholder
    /// - Parameter preferences: global perference
    public init(tipView title:String =  "Tap again to clear", placeholder: String, preferences: EKFieldPreferences = EKFieldMask.staticGlobalPreferences) {
        self.globalPreferences = preferences
        self.tipViewTitle = title
        super.init(preferences: globalPreferences.textField)
        self.placeholder = placeholder
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func configure(){
        super.configure()
        delegate = self
        if let clearBTImage = preferences.clearButtonIcon{
            self.setClearButtonImage(image: clearBTImage)
        }
        self.country = CountryService.shared.localeCountry()
    }
    
    private func setPhoneNumberMask(pattern:String, mask:String) {
        do {
            self.formatter = try EKMaskFormatter(pattern: pattern, mask: mask)
        } catch let error as EKFormatterThrows {
            fatalError(error.localizedDescription)
        }catch { }
    }
    
    // MARK: - Actions
    override func clearButtonTap() {
        Haptic.notification(style: .warning).impact()
        if formatter?.status == .clear {
            self.type = .none
            self.text = nil
        }else {
            if let rightView = rightView {
                let tipView = TipView(text: tipViewTitle, preferences: globalPreferences.tipView)
                tipView.show(view: rightView, animated: true)
            }
            
            formatter.clearMask()
            self.text = formatter.text
            textFieldDidBeginEditing(self)
        }
        sendActions(for: .editingChanged)
    }
    
    override func leftButtonTap() {
        Haptic.impact(style: .light).impact()
        
        let vc = CountryViewController(preferences: globalPreferences.countryView) { (country) in
            self.country = country
            if let img = UIImage(named: country.cc) {
                self.setLeftImage(image: img)
            }
            self.text = self.formatter.text
            self.becomeFirstResponder()
        }
        if let topMostViewController = UIApplication.shared.topMostViewController() {
            vc.modalPresentationStyle = .custom
            topMostViewController.view.endEditing(true)
            topMostViewController.present(vc, animated: false, completion: nil)
        }
    }
}

// MARK: - Extensions & Delegate
extension EKFieldMask: UITextFieldDelegate {
    
    private func detectTextFieldAction(range: NSRange, string: String) -> FieldEvent {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        return isBackSpace == -92 ? .delete : .insert
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.type == .none {
            if let char = Array(string).first {
                self.type = char.isNumber ? .phoneNumber : .email
            }
        }
        if self.type == .email {
            return true
        }
        
        do {
            var position:Int
            switch detectTextFieldAction(range: range, string: string) {
            case .insert:
                let tmpPosition = try formatter.insert(contentsOf: Array(string), from: range.location)
                position =  tmpPosition.next ?? (tmpPosition.current + 1)
            case .delete: position = try formatter.delete(at: range.location).current
            }
            self.text = formatter.text
            sendActions(for: .editingChanged)
            textField.moveCaret(to: position)
        }catch EKFormatterThrows.canNotFindEditableNode(description: _){
            if formatter.status == .clear {
                self.type = .none
                self.text = nil
                sendActions(for: .editingChanged)
            }else {
                Haptic.notification(style: .error).impact()
            }
        }catch {}
        
        return false
    }
    
    open override func deleteBackward() {
        super.deleteBackward()
        if let textCount = self.text?.count, textCount == 0 {
            self.type = .none
            self.shake()
            Haptic.notification(style: .error).impact()
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let caretPosition = formatter.firstEditableNodeIndex, self.type == .phoneNumber {
            textField.moveCaret(to: caretPosition)
        }
    }
}

private extension UIView {
    func shake(duration:Double = 0.07, repeatCount:Float = 2, offset:CGFloat = 2){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - offset, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + offset, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
