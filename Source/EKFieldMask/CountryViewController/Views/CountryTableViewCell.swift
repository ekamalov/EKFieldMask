//
//  CountryTableViewCell.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 6/29/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

final public class CountryTableViewCell: UITableViewCell {
    lazy var icon = UIImageView(frame: .zero)
    lazy var countryName:UILabel = .init(frame: .zero)
    lazy var dialCode:UILabel = .init(frame: .zero)
    lazy var seperatorLine:UIView = .init(frame: .zero)
    
    internal var appearance:CountryTableViewAppearance = CountryTableViewAppearance(){
        willSet {
            countryName.font = newValue.cellTitleFont
            countryName.textColor = newValue.cellTitleColor
            dialCode.font = newValue.cellDetailTextFont
            dialCode.textColor = newValue.cellDetailTextColor
            seperatorLine.backgroundColor = newValue.seperatorLineColor
        }
    }
    
    internal func update(_ country:Country,appearance:CountryTableViewAppearance){
        self.appearance = appearance
        self.icon.image = UIImage(named: country.cc, in: Bundle.resource, compatibleWith: nil)
        countryName.text = country.localizeName
        dialCode.text = "+\(country.dialCode)"
        countryName.sizeToFit()
        dialCode.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dialCode.textAlignment = .right
        icon.layer.cornerRadius = 2
        icon.clipsToBounds = true
        contentView.addSubviews(icon,countryName,dialCode,seperatorLine)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        let yCenter = self.frame.height / 2
        icon.frame = .init(origin: .init(x: 0, y: yCenter - (appearance.cellIconSize.height / 2)), size: appearance.cellIconSize)
        countryName.frame.origin = .init(x: icon.frame.maxX + 8, y: yCenter - (appearance.cellTitleFont.lineHeight / 2))
        dialCode.frame.origin = .init(x: self.frame.width - dialCode.frame.width, y: yCenter - (appearance.cellTitleFont.lineHeight / 2))
        seperatorLine.frame = .init(origin: .init(x: 0, y: frame.height - 1), size: .init(width: frame.width, height: 1))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
