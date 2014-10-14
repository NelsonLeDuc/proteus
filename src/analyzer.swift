//
//  analyzer.swift
//  protc
//
//  Created by David Owens II on 10/13/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

import Foundation


public protocol Construct {
    var identifier: String { get }
    var typeName: String { get }
}

public class EnumOption {
    public let name: String

    init(name: String) {
        self.name = name;
    }
}

public class Enum : Construct {
    public var typeName: String { get { return "enum" } }
    // fun: make this let and BOOM! runtime crash
    public var identifier: String
    public let options: [EnumOption]

    init(name: String, options: [EnumOption]) {
        self.identifier = name;
        self.options = options;
    }
}

public class Analyzer {
    private let path: String
    private var keywords: [String:(token:Token, lexer:Scanner) -> Construct?] = [:]
    private var errorMessages: [String] = []

    public var errors: [String] { get { return self.errorMessages } }

    public init(path: String) {
        self.path = path

        keywords["enum"] = { self.parseEnum($0, lexer: $1) }
    }

    public func analyze() -> [Construct]
    {
        let code = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        if let code = code {
            let lexer = Scanner(content: code)
            return parse(lexer)
        }

        error("file not found.", path: path, position: FilePosition(lineNumber: 0, column: 0))
        return []
    }

    private func error(message: String, path: String, position: FilePosition)
    {
        let output = "\(path):\(position.lineNumber): error: \(message)"
        errorMessages.append(output)
    }

    private func parse(lexer: Scanner) -> [Construct] {
        var constructs = [Construct]()
        
        for token in lexer {
            switch token.type {
            case .Keyword:
                let construct = keywords[token.text]?(token: token, lexer: lexer)
                if let construct = construct {
                    constructs.append(construct)
                }

            default:
                error("unhandled token", path: self.path, position: token.position)
            }
        }

        return constructs
    }

    private func parseEnum(token: Token, lexer: Scanner) -> Construct? {
        let nameToken = lexer.nextToken()
        if nameToken.type != .Identifier {
            error("Expected name for enum.", path: self.path, position: nameToken.position)
            return nil
        }

        let defineToken = lexer.nextToken()
        if defineToken.type != .Colon {
            error("Expected ':' for enum definition.", path: self.path, position: defineToken.position)
            return nil
        }

        // todo: support multi-line definitions, raw values, and associated values

        var options = [EnumOption]()

        var previousToken: Token? = nil
        var optionToken = lexer.nextToken()
        while (true) {
            if optionToken.type == TokenType.NewLine { break; }
            if optionToken.type == TokenType.EndOfFile { break; }

            switch optionToken.type {
            case .Identifier:
                options.append(EnumOption(name: optionToken.text))

            case .Pipe:
                if previousToken == nil {
                    error("Expected name for enum open.", path: self.path, position: optionToken.position)
                    return nil
                }

                if previousToken?.type != TokenType.Identifier {
                    error("The '|' can only come between enum options.", path: self.path, position: optionToken.position)
                    return nil
                }

            default:
                error("Unexpected token while parsing enum.", path: self.path, position: optionToken.position)
                return nil
            }

            previousToken = optionToken
            optionToken = lexer.nextToken()
        }

        if countElements(options) == 0 {
            error("Expected option for enum.", path: self.path, position: optionToken.position)
            return nil
        }

        return Enum(name: nameToken.text, options: options)
    }
}