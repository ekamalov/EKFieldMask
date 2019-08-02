//
//  EKBuilder.swift
//  EKBuilder
//
//  Created by Erik Kamalov on 4/11/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import UIKit

public protocol EKBuilder {
    init()
}
extension EKBuilder {
    
    /// Makes it available to set properties with closures and returns initialized Value.
    ///
    ///     class Test:Builder { // Just make extensions.
    ///         var value:Bool?
    ///         var count:Int!
    ///         required init() {} // init implementation is required for the class, not required for the structure
    ///     }
    ///     struct TestTwo:Builder {
    ///         var value:Bool?
    ///     }
    ///     // Example how use
    ///     let testOne:Test = .build { (test) in
    ///         test.value = true
    ///         test.count = 10
    ///     }
    ///
    ///     let testTwo:TestTwo = .build {
    ///         $0.value = false
    ///         $0.count = 10
    ///     }
    ///
    ///     let testTree = Test.build {
    ///        $0.value = false
    ///        $0.count = 10
    ///     }
    /// - Returns: initialized Value
    public static func build(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = Self.self.init()
        try block(&copy)
        return copy
    }
    
}


extension NSObject: EKBuilder {}
