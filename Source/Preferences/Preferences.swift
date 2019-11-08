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

public struct EKFieldPreferences {
    
    public struct CountryView {

        public struct TableView {
            public struct Header {
                /// Use the titleFont property to change the font of the  title font. By default user "Gilroy-SemiBold"  with size 28
                public var titleFont: UIFont             = UIFont(name: "Gilroy-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
                /// Use the titleColor property to change the color of the title. By default, uses black
                public var titleColor: UIColor           = .black
                /// Use the seperatorLinePadding property to change the left+right padding of the seperator line. By default, uses black with alpha 25
                public var seperatorLinePadding: CGFloat = 25
                /// Use the sectionTitleColor property to change the color of the seperator line. By default, uses black with alpha 0.1
                public var seperatorLineColor: UIColor   = UIColor.black.withAlphaComponent(0.1)
                
                public var searchBar: EKTextField        = EKTextField()
            }
            
            public struct Cell {
                /// Use the flagIconSize property to change the size of the flag imageView. By default, uses .init(width: 20, height: 15)
                public var flagIconSize: CGSize         = .init(width: 20, height: 15)
                /// Use the countryTextFont property to change the font of the  country title. By default user "Gilroy-SemiBold" 16
                public var countryTextFont: UIFont        = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
                /// Use the countryTextColor property to change the color of the country title . By default, uses .init(red: 65/255, green: 78/255, blue: 91/255, alpha: 1)
                public var countryTextColor: UIColor      = .init(red: 65/255, green: 78/255, blue: 91/255, alpha: 1)
                /// Use the dialCodeTextFont property to change the font of the  dial code text. By default user "Gilroy-SemiBold" 16
                public var dialCodeTextFont: UIFont   = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
                /// Use the dialCodeText property to change the color of the dial code text. By default, uses black
                public var dialCodeTextColor: UIColor = .black
                /// Use the height property to change the height of the tableView. By default, user 60
                public var height: CGFloat          = 60
                /// Use the sectionTitleColor property to change the color of the tableView cell seperator line By default, uses black with alpha 0.1
                public var seperatorLineColor: UIColor  = UIColor.black.withAlphaComponent(0.1)
            }
            
            /// Use the sectionHeaderHeight property to change the  cell height of the tableView section height. By default user "50px
            public var sectionHeaderHeight: CGFloat = 50
            /// Use the sectionTitleFont property to change the font of the tableView section title. By default user "Gilroy-SemiBold" 16
            public var sectionTitleFont: UIFont     = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)
            /// Use the sectionTitleColor property to change the color of the tableView section title color. By default, uses black with alpha 0.4
            public var sectionTitleColor: UIColor   = UIColor.black.withAlphaComponent(0.4)
            
            public var cell: Cell                   = Cell()
            public var header: Header               = Header()
        }
        
        public struct MomentumView {
            /// Use the sectionTitleColor property to change the color of the tableView section title color. By default, uses black with alpha 0.4
            public var backgroundColor: UIColor = .white
            /// Use the sectionTitleColor property to change the color of the tableView section title color. By default, uses black with alpha 0.4
            public var cornerRadius: CGFloat    = 20
            /// Use the padding property to change the left-right inside padding of the CountryView . By default, uses 8px
            public var padding: CGFloat         = 8
        }
        /// Use the contentMargin property to change the left-right margin of the main screen. By default, uses 25px
        public var contentMargin: CGFloat               = 25
        /// Use the relatedCountries property to change the list related countries of the countryView. Related countries will be shown at the top of the list. By default, uses "AT","NO","CH","US","UK"
        public var relatedCountries: [String]           = ["AT","NO","CH","US","UK"]
        
        public var tableView: TableView                 = TableView()
        public var momentView: MomentumView             = MomentumView()
    }
    
    public struct EKTextField {
        /// Use the borderWidth property to change the border width of the field  . By default, uses 1px
        public var borderWidth: CGFloat      = 1
        /// Use the sectionTitleColor property to change the color of the tableView section title color. By default, uses black with alpha 0.4
        public var borderColor: UIColor      = UIColor.black.withAlphaComponent(0.1)
        /// Use the cornerRadius property to change the corner radius of the field  . By default, uses 10px
        public var cornerRadius: CGFloat     = 10
        /// Use the leftIcon property to change the search icon of the search field in countriesViewController  . By default, uses search icon
        public var leftIcon: UIImage?        = UIImage(named: "search", in: .framework, compatibleWith: nil) ?? nil
        /// Use the clearButtonIcon property to change the clear icon of the field. By default, uses search icon
        public var clearButtonIcon: UIImage? = UIImage.init(named: "clear", in: .framework, compatibleWith: nil) ?? nil
        /// The text font. By default bold system font with size 18
        public var font: UIFont              = UIFont(name: "Gilroy-SemiBold", size: 18) ?? .boldSystemFont(ofSize: 18)
        /// Use the tintColor property to change the color of the field tint . By default, uses black
        public var tintColor: UIColor        = .black
        /// Use the textColor property to change the  color of the text. By default, uses black
        public var textColor: UIColor        = .black
        /// Use the sectionTitleColor property to change the color of the tableView section title . By default, uses black with alpha 0.4
        public var placeholderColor: UIColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    public var countryView: CountryView = CountryView()
    public var textField: EKTextField   = EKTextField()
    
    public var tipView: TipView.Preferences = TipView.Preferences()
    
    public init() {}
}

