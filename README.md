# Cellular number mask

<img align="left" src="https://github.com/ekamalov/MediaFiles/blob/master/EKMaskField.gif" width="480" height="360"/>

### About
In some cases, during the process registration, cannot design through social networks like e-wallets, bank accounts, etc. In such cases, usually, in applications, for ease of use, developed a particular form for a phone number with a pre-selected country code and convenient number entry. But exist the case when users also should be able to sign up by e-mail. For such an example, we have designed the unique **cellular number mask** that appears when the user starts typing numbers.
###### If you 👍 the project, do not forget ⭐️ me <br> Stay tuned for the latest updates [Follow me](https://github.com/ekamalov) 🤙


[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/ekamalov/EKFieldMask/issues)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Version](https://img.shields.io/github/release/ekamalov/EKFieldMask.svg)](https://github.com/ekamalov/EKFieldMask/releases)
[![CocoaPods](http://img.shields.io/cocoapods/v/EKFieldMask.svg)](https://cocoapods.org/pods/EKFieldMask)
[![Build Status](https://travis-ci.org/ekamalov/EKFieldMask.svg?branch=master)](https://travis-ci.org/ekamalov/EKFieldMask)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/EKFieldMask.svg?style=flat)](http://cocoapods.org/pods/EKFieldMask)

## Requirements

- iOS 12.2+
- Xcode 11+
- Swift 5.0+

## Example
First clone the repo, and run `carthage update` from the root directory.
The example application is the best way to see `EKFieldMask` in action. Simply open the `EKFieldMask.xcodeproj` and run the `Example` scheme.

## Installation

### CocoaPods

EKLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your `Podfile`:

```ruby
pod 'EKFieldMask'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate `EKFieldMask` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ruby
github "ekamalov/EKFieldMask"
```

Run `carthage update` to build the framework and drag the built `EKFieldMask.framework` into your Xcode project.

On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” and add the Framework path as mentioned in [Carthage Getting started Step 4, 5 and 6](https://github.com/Carthage/Carthage/blob/master/README.md#if-youre-building-for-ios-tvos-or-watchos)

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate `EKFieldMask` into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage

After installing the lib and importing the module `EKFieldMask`, the text field can be used like any other text field.

```swift
/// Public initializer
/// - Parameter title: TipView title
/// - Parameter placeholder: text field placeholder
/// - Parameter preferences: global perference
public init(tipView title: String = "Tap again to clear",
			placeholder: String,
			preferences: Preferences = EKFieldMask.staticGlobalPreferences)

/// Example
let maskField: EKFieldMask = EKFieldMask(placeholder: "E-mail or phone number")
//or     
let maskField: EKFieldMask = EKFieldMask(tipView: "Tap again to clear",
 					 placeholder: "E-mail or phone number")

```
If you want to change the appearance look `Customizing` heading

```swift
/// Example
var preferences = EKFieldPreferences()
preferences.tipView.body.backgroundColor = .red
preferences.textField.textColor = .blue
preferences.countryView.tableView.cell.countryTextColor = .black

let field = EKFieldMask(tipView: "Tap again to clear",
                                placeholder: "E-mail or phone number",
                                preferences: preferences)
```

## Customizing

In order to customize the `EKFieldMask` appearance and behavior, you can play with the `Preferences` structure which encapsulates all the customizable properties. These preferences have been split into three structures:

<p align="center"> <img src="https://imgur.com/43IIxJt.png/" width="500" height="300"></p>

### Basic
encapsulates customizable properties specifying how `EKFieldMask` will be drawn on the screen. See the default values:

```swift
/// Use the borderWidth property to change the border width of the field  . By default, uses 1px
public var borderWidth: CGFloat      = 1

/// Use the sectionTitleColor property to change the color of the tableView section title color. By default, uses black with alpha 0.4
public var borderColor: UIColor      = UIColor.black.withAlphaComponent(0.1)

/// Use the cornerRadius property to change the corner radius of the field  . By default, uses 10px
public var cornerRadius: CGFloat     = 10

/// Use the leftIcon property to change the search icon of the search field in countriesViewController  . By default, uses search icon
public var leftIcon: UIImage?        = UIImage(named: "search", in: Bundle.resource, compatibleWith: nil) ?? nil

/// Use the clearButtonIcon property to change the clear icon of the field. By default, uses search icon
public var clearButtonIcon: UIImage? = UIImage.init(named: "clear", in: .resource, compatibleWith: nil) ?? nil

/// The text font. By default bold system font with size 18
public var font: UIFont              = UIFont(name: "Gilroy-SemiBold", size: 18) ?? .boldSystemFont(ofSize: 18)

/// Use the tintColor property to change the color of the field tint . By default, uses black
public var tintColor: UIColor        = .black

/// Use the textColor property to change the  color of the text. By default, uses black
public var textColor: UIColor        = .black

/// Use the sectionTitleColor property to change the color of the tableView section title . By default, uses black with alpha 0.4
public var placeholderColor: UIColor = UIColor.black.withAlphaComponent(0.4)
```
### Country View Controller
encapsulates customizable properties specifying how `Country view appearance choose country` will be drawn on the screen. See the default values:

```swift
/// Use the contentMargin property to change the left-right margin of the main screen. By default, uses 25px
public var contentMargin: CGFloat     = 25

/// Use the relatedCountries property to change the list related countries of the countryView. Related countries will be shown at the top of the list. By default, uses "AT","NO","CH","US","UK"
public var relatedCountries: [String] = ["AT","NO","CH","US","UK"]
```
#### Header
You can format `Header` with your own parameters. Use this to get your desired style. See the default values:

```swift
 /// Use the titleFont property to change the font of the  title font. By default user "Gilroy-SemiBold"  with size 28
public var titleFont: UIFont             = UIFont(name: "Gilroy-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)

/// Use the titleColor property to change the color of the title. By default, uses black
public var titleColor: UIColor           = .black

/// Use the seperatorLinePadding property to change the left+right padding of the seperator line. By default, uses black with alpha 25
public var seperatorLinePadding: CGFloat = 25

/// Use the sectionTitleColor property to change the color of the seperator line. By default, uses black with alpha 0.1
public var seperatorLineColor: UIColor   = UIColor.black.withAlphaComponent(0.1)
```
#### Cell
You can format `Cell` with your own parameters. Use this to get your desired style. See the default values:

```swift
/// Use the flagIconSize property to change the size of the flag imageView. By default, uses .init(width: 20, height: 15)
public var flagIconSize: CGSize        = .init(width: 20, height: 15)

/// Use the countryTextFont property to change the font of the  country title. By default user "Gilroy-SemiBold" 16
public var countryTextFont: UIFont     = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)

/// Use the countryTextColor property to change the color of the country title . By default, uses .init(red: 65/255, green: 78/255, blue: 91/255, alpha: 1)
public var countryTextColor: UIColor   = .init(red: 65/255, green: 78/255, blue: 91/255, alpha: 1)

/// Use the dialCodeTextFont property to change the font of the  dial code text. By default user "Gilroy-SemiBold" 16
public var dialCodeTextFont: UIFont    = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)

/// Use the dialCodeText property to change the color of the dial code text. By default, uses black
public var dialCodeTextColor: UIColor  = .black

/// Use the height property to change the height of the tableView. By default, user 60
public var height: CGFloat             = 60

/// Use the sectionTitleColor property to change the color of the tableView cell seperator line By default, uses black with alpha 0.1
public var seperatorLineColor: UIColor = UIColor.black.withAlphaComponent(0.1)
```
#### Section
Use this to get your desired style.. See the default values:

```swift
/// Use the sectionHeaderHeight property to change the  cell height of the tableView section height. By default user "50px
public var sectionHeaderHeight: CGFloat = 50

/// Use the sectionTitleFont property to change the font of the tableView section title. By default user "Gilroy-SemiBold" 16
public var sectionTitleFont: UIFont     = UIFont(name: "Gilroy-SemiBold", size: 16) ?? .boldSystemFont(ofSize: 16)

/// Use the sectionTitleColor property to change the color of the tableView section title color. By default, uses black with alpha 0.4
public var sectionTitleColor: UIColor   = UIColor.black.withAlphaComponent(0.4)
```
## Contributing
Contributions are very welcome 🙌

## License
`EKFieldMask`  is released under the MIT license. Check LICENSE.md for details.

```
  MIT License

  Copyright (c) 2019 Erik Kamalov <ekamalov967@gmail.com>

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
```
