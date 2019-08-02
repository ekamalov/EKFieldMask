//
//  Extensions.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 6/28/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

/// MARK: - Builder, you can look documentation in GitHub(https://github.com/erikkamalov/EKBuilder.git)
public protocol Builder {
    init()
}
extension Builder {
    public static func build(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = Self.self.init()
        try block(&copy)
        return copy
    }
}
extension NSObject: Builder {}

extension UIView {
    func addSubviews(_ views:UIView...){
        views.forEach { addSubview($0) }
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}


extension UITextField {
    func moveCaret(to position:Int) {
        guard let caretPosition = self.position(from: self.beginningOfDocument, offset: position) else {
            return
        }
        self.selectedTextRange = self.textRange(from: caretPosition, to: caretPosition)
    }
}

public extension Bundle {
    class var resource:Bundle {
        let bundle = Bundle(for: EKFieldMask.self)
        
        if let path = bundle.path(forResource: "EKFieldMask", ofType: "bundle") {
            return Bundle(path: path)!
        } else {
            return bundle
        }
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UIView {
    func roundedRadius() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
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

enum Haptic {
    case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(style: UINotificationFeedbackGenerator.FeedbackType)
    case selection
    
    func impact(){
        switch self {
        case .impact(style: let style):
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: style)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        case .notification(style: let style):
            let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator.notificationOccurred(style)
        default:
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
}
