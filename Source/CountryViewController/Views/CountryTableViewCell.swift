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

final public class CountryTableViewCell: UITableViewCell {
    // MARK: - Properties
    lazy var icon = UIImageView(frame: .zero)
    lazy var countryName:UILabel = .init(frame: .zero)
    lazy var dialCode:UILabel = .init(frame: .zero)
    lazy var seperatorLine:UIView = .init(frame: .zero)
    
    internal var preferences: EKFieldPreferences.CountryView.TableView.Cell = EKFieldPreferences.CountryView.TableView.Cell() {
        willSet {
            countryName.font = newValue.countryTextFont
            countryName.textColor = newValue.countryTextColor
            dialCode.font = newValue.dialCodeTextFont
            dialCode.textColor = newValue.dialCodeTextColor
            seperatorLine.backgroundColor = newValue.seperatorLineColor
        }
    }
    
    internal func update(_ country:Country, preferences: EKFieldPreferences.CountryView.TableView.Cell){
        self.preferences = preferences
        self.icon.image = UIImage(named: country.cc, in: .framework, compatibleWith: nil)
        countryName.text = country.localizeName
        dialCode.text = "+\(country.dialCode)"
        countryName.sizeToFit()
        dialCode.sizeToFit()
    }
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dialCode.textAlignment = .right
        contentView.addSubviews(icon,countryName,dialCode,seperatorLine)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouting
    override public func layoutSubviews() {
        super.layoutSubviews()
        let yCenter = self.frame.height / 2
        icon.frame = .init(origin: .init(x: 0, y: yCenter - (preferences.flagIconSize.height / 2)), size: preferences.flagIconSize)
        countryName.frame.origin = .init(x: icon.frame.maxX + 8, y: yCenter - (preferences.countryTextFont.lineHeight / 2))
        dialCode.frame.origin = .init(x: self.frame.width - dialCode.frame.width, y: yCenter - (preferences.countryTextFont.lineHeight / 2))
        seperatorLine.frame = .init(origin: .init(x: 0, y: frame.height - 1), size: .init(width: frame.width, height: 1))
    }
    
}
