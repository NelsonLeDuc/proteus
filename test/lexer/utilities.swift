//
//  utilities.swift
//  protc
//
//  Created by David Owens II on 10/13/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

import Foundation
import XCTest

func pathForFile(name: String, #type: String) -> String
{
    let bundle = NSBundle(forClass: lexer_enum_tests.self)
    return bundle.pathForResource(name, ofType: type) ?? ""
}

func stringForFile(file: String, #type: String) -> String?
{
    let bundle = NSBundle(forClass: lexer_enum_tests.self)
    let path = bundle.pathForResource(file, ofType: type)
    if let path = path {
        return String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
    }
    else {
        return nil
    }
}

func assertEqual(stringA: String?, stringB: String?)
{
    XCTAssertTrue(stringA != nil)
    XCTAssertTrue(stringB != nil)
    if (stringA == nil || stringB == nil) { return }

    let linesA = stringA!.componentsSeparatedByString("\n")
    let linesB = stringB!.componentsSeparatedByString("\n")

    for idx in 0..<linesA.count {
        if idx >= linesB.count { break; }

        XCTAssertEqual(linesA[idx], linesB[idx], "\nLeft: \n\(context(linesA, idx))\nRight:\n\(context(linesB, idx))")
    }

    XCTAssertEqual(linesA.count, linesB.count)
}

private func context(lines: [String], index: Int) -> String
{
    var context = ""
    if index > 1 { context = "\(index - 1): \(lines[index - 1])\n" }
    context += "\(index): \(lines[index])\n"
    if index < lines.count - 1 { context += "\(index + 1): \(lines[index + 1])\n" }

    return context
}