//
//  analyzer_enum_tests.swift
//  protc
//
//  Created by David Owens II on 10/13/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

import XCTest

class analyzer_enum_tests: XCTestCase {

    func testAnalyzingEnumSingleLineStandardSpacing()
    {
        let path = pathForFile("enum_basic_singleline", type: "prot")
        let analyzer = Analyzer(path: path)
        let constructs = analyzer.analyze()

        let count = countElements(constructs)
        XCTAssertEqual(countElements(constructs), 1)

        if count > 0 {
            let construct = constructs[0] as? Enum
            XCTAssertTrue(construct != nil)

            if let construct = construct {
                XCTAssertTrue(construct.identifier == "CompassPoint")
                XCTAssertTrue(construct.options.count == 4)

                XCTAssertTrue(construct.options[0].name == "North")
                XCTAssertTrue(construct.options[1].name == "South")
                XCTAssertTrue(construct.options[2].name == "East")
                XCTAssertTrue(construct.options[3].name == "West")
            }
        }
    }

}
