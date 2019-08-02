<img src="https://github.com/erikkamalov/EKBuilder/blob/master/Resource/logo.svg"/>

# Builder

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/erikkamalov/EKBuilder/issues)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Version](https://img.shields.io/github/release/erikkamalov/EKBuilder.svg)](https://github.com/erikkamalov/EKBuilder/releases) 
[![CocoaPods](http://img.shields.io/cocoapods/v/EKBuilder.svg)](https://cocoapods.org/pods/EKBuilder)
[![Build Status](https://travis-ci.org/erikkamalov/EKBuilder.svg?branch=master)](https://travis-ci.org/erikkamalov/EKBuilder)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

✋ ✋ ✋ The super easy and generic builder pattern. It's easy if you try 💪.

## Introduction

Initialize UIView **build** set its properties. 👍 👍

```swift
let label:UIView = .build{
  $0.backgroundColor = .red
  $0.clipsToBounds = true
}
```

 👇  👇 This is equivalent to:  👇 👇

```swift
let label: UIView = {
  let view = UIView()
  view.backgroundColor = .red
  view.clipsToBounds = true
  return view
}()
```

## Tips and examples

- ###### You can use `build` to all of `NSObject` subclasses.

    ```swift
    let view = UIView.build { // Example 1
      $0.color = .red
    }
    ```
    
	```swift
	let view:UIView = .build { (view) in // Example 2
       view.color = .red
    }
	```
	
	```swift
	let view:UIView = .build { // Example 2
      $0.color = .red
    }
	```

- ###### You can use `build` to all of `class and structure`. Just make extensions. Init implementation is required for the class, not required for the structure 

    ```swift
    extension UserType: EKBuilder {}
    
    let instance:UserType = .build{
      $0.value = "it's easy if you try!"
    }
    ```

- ###### Example: Here's an example usage in an UIViewController subclass.

	```swift
	 class Tesla: EKBuilder {
	        var type:String!
	        var count:Int!
	        required init() {}
	 }
	 
	 struct Audi:EKBuilder {
	        var type:String!
	        var count:Int!
	 }
	
	final class ViewController: UIViewController {
	
	  let tesla:Tesla = .build {
	    $0.type = "Model X"
	    $0.count = 10
	  }
	
	  let audi = Audi.build {
	     $0.type = "R8"
	     $0.count = 10
	  }
	
	  override func viewDidLoad() {
	    super.viewDidLoad()
	    print(tesla.type, tesla.count)
	    print(audi.type, audi.count)
	  }
	
	}
	```


## Installation

### CocoaPods

Add the following entry to your Podfile:

```rb
pod 'EKBuilder'
```

Then run `pod install`.

Don't forget to `import EKBuilder` in every file you'd like to use Hero.

### Carthage

Add the following entry to your `Cartfile`:

```
github "erikkamalov/EKBuilder"
```

Then run `carthage update`.

If this is your first time using Carthage in the project, you'll need to go through some additional steps as explained [over at Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

## License

**EKBuilder** is under MIT license. See the [LICENSE](LICENSE) file for more info.
