//
//  enum.swift
//  protc
//
//  Created by David Owens II on 10/12/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

import XCTest

class lexer_enum_tests: XCTestCase {

    func testScanningEnumSingleLineStandardSpacing()
    {
        let content = stringForFile("enum_basic_singleline", type: "prot")
        XCTAssertNotNil(content)

        let lexer = Lexer(content: content ?? "")

        let first = lexer.nextToken()
        XCTAssertTrue(first.type == TokenType.Keyword)
        XCTAssertTrue(first.text == "enum")

        var next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Identifier)
        XCTAssertTrue(next.text == "CompassPoint")

        next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Colon)
        XCTAssertTrue(next.text == ":")

        next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Identifier)
        XCTAssertTrue(next.text == "North")

        next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Pipe)
        XCTAssertTrue(next.text == "|")

        next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Identifier)
        XCTAssertTrue(next.text == "South")

        next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Pipe)
        XCTAssertTrue(next.text == "|")

        next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Identifier)
        XCTAssertTrue(next.text == "East")

        next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Pipe)
        XCTAssertTrue(next.text == "|")

        next = lexer.nextToken()
        XCTAssertTrue(next.type == TokenType.Identifier)
        XCTAssertTrue(next.text == "West")
    }

}
