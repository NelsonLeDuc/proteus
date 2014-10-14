//
//  main.swift
//  protc
//
//  Created by David Owens II on 10/12/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

import Foundation

// NYI: error handling yet, usage, etc... basically everything to make this actually useful

let stderr = NSFileHandle.fileHandleWithStandardError()

let file = NSUserDefaults.standardUserDefaults().stringForKey("file")
let output = NSUserDefaults.standardUserDefaults().stringForKey("output") ?? "./output"

NSFileManager.defaultManager().createDirectoryAtPath(output, withIntermediateDirectories: true, attributes: nil, error: nil)

if let file = file {
    let analyzer = Analyzer(path: file)
    let constructs = analyzer.analyze()

    if let firstError = analyzer.errors.first {
        let data = "\(firstError)\n".dataUsingEncoding(NSUTF8StringEncoding)
        if let data = data {
            stderr.writeData(data)
        }
    }
    else {
        for construct in constructs {
            let result = rewriters[construct.typeName]?(construct: construct)
            if let result = result {
                let header = "#import <Foundation/Foundation.h>\n\n\(result.header)"

                header.writeToFile("\(output)/\(construct.identifier).h", atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                result.implementation.writeToFile("\(output)/\(construct.identifier).m", atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            }
        }
    }
}

stderr.closeFile()
