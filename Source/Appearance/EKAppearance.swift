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

public struct  EKCountryViewApperance {
    public init() {}
    
    public var titleFont:UIFont = UIFont(name: "Gilroy-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
    public var titleColor:UIColor = .black
    
    public var dropDownIcon:UIImage? = UIImage(named: "arrow", in: Bundle.resource, compatibleWith: nil) ?? nil
    public var dropDownIconSize:CGSize = .init(width: 34, height: 10)
    
    public var contentMargin:CGFloat = 25
    public var relatedCountries:[String] = ["AT","NO","CH","US","UK"]
    
    public var momentumViewBackgroundColor:UIColor = .white
    public var momentumViewCornerRadius:CGFloat = 20
    public var momentumViewPadding:CGFloat = 8
    
    public var searchBar:EKTextFieldAppearance = EKTextFieldAppearance()
    public var tableView:CountryTableViewAppearance = CountryTableViewAppearance()
}

public struct CountryTableViewAppearance {
    public init() {}
    
    public var headerFont:UIFont = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
    public var headerTextColor:UIColor = UIColor.black.withAlphaComponent(0.4)
    public var cell:CountryTableViewCellAppearance = CountryTableViewCellAppearance()
    public var seperatorLineColor:UIColor = UIColor.black.withAlphaComponent(0.1)
    public var cellHeight:CGFloat = 60
    public var sectionHeaderHeight:CGFloat = 50
}

public struct CountryTableViewCellAppearance {
    public init() {}
    
    public var iconSize:CGSize = .init(width: 20, height: 15)
    public var titleFont:UIFont = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
    public var titleColor:UIColor = .init(red: 65/255, green: 78/255, blue: 91/255, alpha: 1)
    
    public var detailTextFont:UIFont = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
    public var detailTextColor:UIColor = .black
    public var seperatorLineColor:UIColor = UIColor.black.withAlphaComponent(0.1)
}

public struct EKTextFieldAppearance {
    public init() {}
    
    public var borderWidth:CGFloat = 1
    public var borderColor:UIColor = UIColor.black.withAlphaComponent(0.1)
    public var cornerRadius:CGFloat = 10
    
    public var leftIcon:UIImage? = UIImage(named: "search", in: Bundle.resource, compatibleWith: nil) ?? nil
    public var clearButtonIcon:UIImage? = UIImage.init(named: "clear", in: .resource, compatibleWith: nil) ?? nil
    
    public var font:UIFont = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 18)
    public var tintColor:UIColor = .black
    public var textColor:UIColor = UIColor.black
    public var placeholderColor:UIColor = UIColor.black.withAlphaComponent(0.4)
    
}


