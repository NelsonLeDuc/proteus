//
//  rewriter.swift
//  protc
//
//  Created by David Owens II on 10/13/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

typealias rewriter = (construct: Construct) -> (header: String, implementation: String)

let rewriters: [String:rewriter] = ["enum" : rewriteEnumToObjC]

