//
//  rewriter_enum_tests.swift
//  protc
//
//  Created by David Owens II on 10/13/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

import XCTest

class rewriter_enum_tests: XCTestCase {

    func testAnalyzingEnumSingleLineStandardSpacing()
    {
        let path = pathForFile("enum_basic_singleline", type: "prot")
        let header = stringForFile("enum_basic_singleline", type: "h_prot")
        let implementation = stringForFile("enum_basic_singleline", type: "m_prot")

        let analyzer = Analyzer(path: path)
        let constructs = analyzer.analyze()
        XCTAssertFalse(constructs.isEmpty)

        if let enumConstruct = constructs.first {
            let result = rewriteEnumToObjC(enumConstruct)
            assertEqual(result.header, header)
            assertEqual(result.implementation, implementation)
        }
        else {
            XCTFail()
        }
    }
}
