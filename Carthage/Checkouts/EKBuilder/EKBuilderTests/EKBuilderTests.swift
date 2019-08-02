//
//  EKBuilderTests.swift
//  EKBuilderTests
//
//  Created by Erik Kamalov on 4/11/19.
//  Copyright © 2019 Neuron. All rights reserved.
//

import XCTest
@testable import EKBuilder

class EKBuilderTests: XCTestCase {
    /// Class for testing
    class ClassBuilder: EKBuilder {
        var value:Bool!
        var count:Int!
        required init() {}
    }
    /// Structure for testing
    struct StructureBuilder:EKBuilder {
        var value:Bool?
    }
    
    func testClassBuilder(){
        let testOneFalse:ClassBuilder = ClassBuilder()
        testOneFalse.value = false
        
        let testOneTrue:ClassBuilder = ClassBuilder()
        testOneTrue.value = true
        
        let testBuilderByFullClosure:ClassBuilder = .build { (test) in // full clusore test
            test.value = true
        }
        
        XCTAssertEqual(testBuilderByFullClosure.value, testOneTrue.value)
        
        let testBuilderByShortClusure:ClassBuilder = .build { // short closure test
            $0.value = false
            $0.count = 0
        }
        
        XCTAssertEqual(testBuilderByShortClusure.value, testOneFalse.value)
        
        let testByBuilder = ClassBuilder.build {
            $0.value = false
        }
        XCTAssertEqual(testByBuilder.value, testOneFalse.value)
        
    }
    func testStructureBuilder(){
        let testOneFalse:StructureBuilder = StructureBuilder(value: false)
        let testOneTrue:StructureBuilder = StructureBuilder(value: true)
        
        let testBuilderByFullClosure:ClassBuilder = .build { (test) in // full clusore test
            test.value = true
        }
        
        XCTAssertEqual(testBuilderByFullClosure.value, testOneTrue.value)
        
        let testBuilderByShortClusure:ClassBuilder = .build { // short closure test
            $0.value = false
        }
        
        XCTAssertEqual(testBuilderByShortClusure.value, testOneFalse.value)
        
        
        let testByBuilder = ClassBuilder.build {
            $0.value = false
        }
        XCTAssertEqual(testByBuilder.value, testOneFalse.value)
    }
    func testNSObjectBuilder(){
        let label:UILabel = .build {
            $0.text = "test"
        }
        XCTAssertEqual(label.text, "test")
    }
   
}
