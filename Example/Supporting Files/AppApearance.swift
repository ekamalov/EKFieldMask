//
//  AppApearance.swift
//  Example
//
//  Created by Erik Kamalov on 6/27/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

enum Colors {
    case authWrapperTitle
    case nextButton
    case forgot
    case textField
    case custom(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}
extension Colors {
    var value: UIColor {
        var instanceColor = UIColor.clear
        switch self {
        case .authWrapperTitle:
            instanceColor =  .black
        case .nextButton:
            instanceColor = UIColor.black
        case .forgot:
            instanceColor = .black
        case .custom(let red,let green,let blue, let opacity):
            instanceColor = .init(red: red, green: green, blue: blue, alpha: opacity)
        case .textField:
            instanceColor = UIColor.black.withAlphaComponent(0.4)
        }
        return instanceColor
    }
}


enum Fonts:String {
    case GilroyBold = "Gilroy-Bold"
    case GilroySemiBold = "Gilroy-SemiBold"
}

extension Fonts {
    enum StandardSize: CGFloat {
        case h1 = 20.0
        case h2 = 18.0
    }
    func withSize(_ size: StandardSize) -> UIFont {
        return value.withSize(size.rawValue)
    }
    func withSize(_ size: CGFloat) -> UIFont {
        return value.withSize(size)
    }
    
    ///  Default size 16
    var value: UIFont {
        var instanceFont: UIFont!
        guard let font =  UIFont(name: self.rawValue, size: 16) else {
            fatalError("\(self.rawValue) font is not installed, make sure it added in Info.plist and logged with Fonts.logAllAvailableFonts()")
        }
        instanceFont = font
        return instanceFont
    }
    
    static func logAllAvailableFonts(){
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}


