//
//  scanner.swift
//  protc
//
//  Created by David Owens II on 10/12/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

public struct FilePosition {
    let lineNumber: UInt64
    let column: UInt64
}

public enum TokenType {
    case Error
    case Identifier
    case Keyword
    case Indent
    case NewLine
    case Colon
    case Pipe
    case Operator
    case EndOfFile
}

public struct Token {
    public let type: TokenType
    public let text: String
    public let position: FilePosition
}

private let keywords = ["enum"]

public class Scanner : SequenceType
{
    private let tabSize = 4

    private let content: String
    private var enumerator: IndexingGenerator<String>
    private var previousChar: Character? = nil

    private var previousToken: Token? = nil

    private var lineNumber: UInt64 = 1
    private var column: UInt64 = 0

    public init(content: String) {
        self.content = content
        self.enumerator = content.generate()

        next()
    }

    public func generate() -> GeneratorOf<Token> {
        return GeneratorOf<Token>() {
            if self.previousToken?.type == TokenType.EndOfFile {
                return nil
            }
            else {
                return self.nextToken()
            }
        }
    }

    func nextToken() -> Token {
        self.previousToken = { () -> Token in
            if self.previousChar == nil {
                return Token(type: .EndOfFile, text: "", position: FilePosition(lineNumber: self.lineNumber, column: self.column))
            }

            var value = ""

            if self.previousChar == "\n" {
                self.next()
                while self.previousChar == " " || self.previousChar == "\t" {
                    value += "\(self.previousChar!)"
                    self.next()
                }

                if countElements(value) != 0 {
                    return Token(type: .Indent, text: value, position: FilePosition(lineNumber: self.lineNumber, column: self.column))
                }
            }

            if self.previousChar == " " || self.previousChar == "\t" {
                while self.previousChar == " " || self.previousChar == "\t" { self.next() }
            }

            if self.isLetter(self.previousChar) {
                while self.isLetter(self.previousChar) {
                    value += "\(self.previousChar!)"
                    self.next()
                }

                let type = contains(keywords, value) ? TokenType.Keyword : TokenType.Identifier
                return Token(type: type, text: value, position: FilePosition(lineNumber: self.lineNumber, column: self.column))
            }

            // todo: support look-ahead when actually needed

            if self.previousChar == ":" {
                self.next()
                return Token(type: .Colon, text: ":", position: FilePosition(lineNumber: self.lineNumber, column: self.column))
            }

            if self.previousChar == "|" {
                self.next()
                return Token(type: .Pipe, text: "|", position: FilePosition(lineNumber: self.lineNumber, column: self.column))
            }

            return Token(type: .Error, text: "<invalid state>", position: FilePosition(lineNumber: self.lineNumber, column: self.column))
        }()

        return previousToken ?? Token(type: .Error, text: "<invalid state>", position: FilePosition(lineNumber: self.lineNumber, column: self.column))
    }

    private func next() {
        previousChar = self.enumerator.next()
        if previousChar == "\n" {
            lineNumber++
            column = 0
        }
        else if previousChar == "\t" {
            column += tabSize
        }
        else {
            column++
        }
    }

    private func isLetter(c: Character?) -> Bool {
        if let c = c {
            switch c {
            case "a"..."z": return true
            case "A"..."Z": return true
            default: return false
            }
        }
        else {
            return false
        }
    }
}
