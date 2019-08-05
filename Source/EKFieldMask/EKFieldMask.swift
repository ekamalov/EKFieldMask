//
//  SearchTextField.swift
//  Example
//
//  Created by Erik Kamalov on 6/29/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

open class EKFieldMask: CustomTextField {
    public override func setLeftImage(image: UIImage) {
        leftViewMode = .always
        let view = UIView.init(frame: .init(origin: .zero, size: leftViewRect(forBounds: self.bounds).size))
        let img = sideImageViewConfigurator(image: image, frame: .init(origin: .zero, size: view.frame.size),selector: #selector(leftButtonTap))
        img.roundedRadius()
        
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .init(width: 0, height: 1)
        view.layer.shadowRadius = 8
        view.addSubview(img)
        leftView = view
    }
    var formatter:EKMaskFormatter!
    var country:Country? {
        willSet {
            guard let value = newValue else { return }
            setPhoneNumberMask(pattern: value.pattern, mask: value.mask)
        }
    }
    
    var type:EKFieldMaskTextType = .none {
        willSet {
            switch newValue {
            case .email, .none:
                self.leftView = nil
                self.keyboardType = .emailAddress
            case .phoneNumber:
                self.keyboardType = .phonePad
                if let flagName = country?.cc, let flagImage = UIImage(named: flagName, in: .resource, compatibleWith: nil) {
                    self.setLeftImage(image: flagImage)
                }
            }
            reloadInputViews()
        }
    }
    
    enum FieldEvent {
        case delete,insert
    }
    enum EKFieldMaskTextType {
        case email,phoneNumber, none
    }
    
    internal override func configure(){
        super.configure()
        delegate = self
        if let clearBTImage = appearance.rightIcon{
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
    
    override func clearButtonTap() {
        Haptic.notification(style: .warning).impact()
        if formatter?.status == .clear {
            self.type = .none
            self.text = nil
        }else {
            formatter.clearMask()
            self.text = formatter.text
            textFieldDidBeginEditing(self)
        }
    }
    override func leftButtonTap() {
        Haptic.impact(style: .light).impact()
        let vc = CountryViewController(appearance: EKCountryViewApperance()) { (country) in
            self.country = country
            if let img = UIImage(named: country.cc, in: .resource, compatibleWith: nil) {
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

// MARK: - Delegates
extension EKFieldMask: UITextFieldDelegate {
    private func detectTextFieldAction(range: NSRange, string: String) -> FieldEvent {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        return isBackSpace == -92 ? .delete : .insert
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch self.type {
        case .none:
            if let char = Array(string).first {
                self.type = char.isNumber ? .phoneNumber : .email
            }
        case .email: return true
        case .phoneNumber:
            do {
                var position:Int
                switch detectTextFieldAction(range: range, string: string) {
                case .insert:
                    let tmpPosition = try formatter.insert(contentsOf: Array(string), from: range.location)
                    position =  tmpPosition.next ?? (tmpPosition.current + 1)
                case .delete: position = try formatter.delete(at: range.location).current
                }
                self.text = formatter.text
                textField.moveCaret(to: position)
            }catch EKFormatterThrows.canNotFindEditableNode(description: _){
                if formatter.status == .clear {
                    self.type = .none
                    self.text = nil
                }else {
                    Haptic.notification(style: .error).impact()
                }
            }catch {}
        }
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
