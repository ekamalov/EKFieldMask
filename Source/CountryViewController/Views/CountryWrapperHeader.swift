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

internal class SearchTextField: CustomTextField, UITextFieldDelegate {
    override func configure() {
        super.configure()
        if let rightIcon = appearance.clearButtonIcon {
            setClearButtonImage(image: rightIcon)
        }
        if let leftIcon = appearance.leftIcon {
            setLeftImage(image: leftIcon)
        }
        self.delegate = self
    }
    override func clearButtonTap() {
        Haptic.notification(style: .warning).impact()
        self.text?.removeAll()
        sendActions(for: .editingChanged)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: 15, y: (bounds.height - 16) / 2 , width: 16, height: 16)
    }
}

class CountryWrapperHeader: UIView {
    
    lazy var dropDownIcon:UIImageView  = .build {
        $0.image = appearance.dropDownIcon
        $0.frame.size = appearance.dropDownIconSize
    }
    
    lazy var momentViewTitle:UILabel = .build {
        $0.text = "Countries"
        $0.textAlignment = .center
        $0.font = appearance.titleFont
        $0.textColor = appearance.titleColor
        $0.sizeToFit()
    }
    
    lazy var seperatorLine:UIView = .build {
        $0.backgroundColor = appearance.tableView.seperatorLineColor
    }
    
    lazy var searchTextField:SearchTextField = .build {
        $0.placeholder = "Search countries"
    }
    
    private var appearance:EKCountryViewApperance
    
    init(appearance: EKCountryViewApperance) {
        self.appearance = appearance
        super.init(frame: .zero)
        searchTextField.setAppearance(appearance: appearance.searchBar)
        addSubviews(dropDownIcon,momentViewTitle,seperatorLine,searchTextField)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropDownIcon.frame.origin = CGPoint(x:(self.frame.width / 2) - appearance.dropDownIconSize.width / 2, y: self.bounds.height * 0.111)
        momentViewTitle.frame = .init(x: 0, y: dropDownIcon.frame.maxY + 10, width: self.frame.width, height:appearance.titleFont.lineHeight)
        
        seperatorLine.frame = .init(origin: .init(x: appearance.contentMargin, y: momentViewTitle.frame.maxY + 15),
                                    size: .init(width: self.frame.width - (appearance.contentMargin * 2), height: 1))
        
        searchTextField.frame = .init(x: seperatorLine.frame.minX, y: seperatorLine.frame.maxY + 20, width: seperatorLine.bounds.width, height: self.bounds.height * 0.368)
    }
}


