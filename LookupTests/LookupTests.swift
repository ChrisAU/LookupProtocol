//
//  LookupTests.swift
//  LookupTests
//
//  Created by Chris Nevin on 26/06/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import XCTest
@testable import Lookup

internal func hashValue(word: String) -> String {
    return String(word.characters.sort())
}

internal func hashValue(characters: [Character]) -> String {
    return String(characters.sort())
}

struct FakeDictionary: Lookup {
    let words: Words
    
    subscript(letters: [Character]) -> Anagrams? {
        return words[hashValue(letters)]
    }
    
    func lookup(word: String) -> Bool {
        return self[hashValue(word)]?.contains(word) ?? false
    }
}

class LookupTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLookupSucceeds() {
        let words = ["aprt": ["part", "trap"]]
        let dict = FakeDictionary(words: words)
        XCTAssertTrue(dict.lookup("trap"))
    }
    
    func testLookupFailsHash() {
        let words = ["aprt": ["part", "trap"]]
        let dict = FakeDictionary(words: words)
        XCTAssertFalse(dict.lookup("rapt"))
    }
    
    func testLookupFails() {
        let words = ["aprt": ["part", "trap"]]
        let dict = FakeDictionary(words: words)
        XCTAssertFalse(dict.lookup("fake"))
    }
    
    func testAnagramsSucceeds() {
        let words = ["aprt": ["part", "trap"]]
        let dict = FakeDictionary(words: words)
        XCTAssertEqual(dict["trap"]!, ["part", "trap"])
    }
    
    func testAnagramsFails() {
        let words = ["aprt": ["part", "trap"]]
        let dict = FakeDictionary(words: words)
        XCTAssertNil(dict["fake"])
    }
    
    func testAnagramsWithFixedLettersSucceeds() {
        let words = ["aprt": ["part", "trap"]]
        let dict = FakeDictionary(words: words)
        XCTAssertEqual(dict["trap", [0: "p"]]!, ["part"])
    }
    
    func testAnagramsWithFixedLettersFails() {
        let words = ["aprt": ["part", "trap"]]
        let dict = FakeDictionary(words: words)
        XCTAssertEqual(dict["trap", [3: "r"]]!, [])
    }
}
