//
//  EKAppearance.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 6/28/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

public struct EKCountryViewApperance:Builder {
    public init() {}
    
    var titleFont:UIFont = UIFont(name: "Gilroy-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
    var titleColor:UIColor = .black
    
    var dropDownIcon:UIImage? = UIImage(named: "arrow", in: Bundle.resource, compatibleWith: nil) ?? nil
    var dropDownIconSize:CGSize = .init(width: 34, height: 10)
    
    var contentMargin:CGFloat = 25
    var relatedCountries:[String] = ["AT","NO","CH","US","UK"]
    
    var momentumViewBackgroundColor:UIColor = .white
    var momentumViewCornerRadius:CGFloat = 20
    var momentumViewPadding:CGFloat = 8
    
    public var searchBar:EKTextFieldAppearance = EKTextFieldAppearance()
    public var tableView:CountryTableViewAppearance = CountryTableViewAppearance()
}

public struct CountryTableViewAppearance {
    var headerFont:UIFont = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
    var headerTextColor:UIColor = UIColor.black.withAlphaComponent(0.4)
    var cell:CountryTableViewCellAppearance = CountryTableViewCellAppearance()
    var seperatorLineColor:UIColor = UIColor.black.withAlphaComponent(0.1)
    var cellHeight:CGFloat = 60
    var sectionHeaderHeight:CGFloat = 50
}

public struct CountryTableViewCellAppearance {
    var iconSize:CGSize = .init(width: 20, height: 15)
    var titleFont:UIFont = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
    var titleColor:UIColor = .init(red: 65/255, green: 78/255, blue: 91/255, alpha: 1)
    
    var detailTextFont:UIFont = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
    var detailTextColor:UIColor = .black
    var seperatorLineColor:UIColor = UIColor.black.withAlphaComponent(0.1)
}

public struct EKTextFieldAppearance {
    var borderWidth:CGFloat = 1
    var borderColor:UIColor = UIColor.black.withAlphaComponent(0.1)
    var cornerRadius:CGFloat = 10
    var leftIcon:UIImage? = UIImage(named: "search", in: Bundle.resource, compatibleWith: nil) ?? nil
    var rightIcon:UIImage? = UIImage.init(named: "clear", in: .resource, compatibleWith: nil) ?? nil
    var textColor:UIColor = UIColor.black
    var placeholderColor:UIColor = UIColor.black.withAlphaComponent(0.4)
    var font:UIFont = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 18)
    var tintColor:UIColor = .black
}


