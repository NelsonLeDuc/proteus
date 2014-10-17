//
//  scanner.swift
//  protc
//
//  Created by David Owens II on 10/12/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

/// Represents the semantic position in the file.
public struct FilePosition {
    /// The line number, starting at 1.
    public let lineNumber: UInt64

    /// The column of the first character of the item represented.
    public func column(numberOfSpacesPerTab:UInt64 = 4) -> UInt64 {
        return numberOfSpacesPerTab * numberOfTabs + numberOfSpaces
    }

    /// The number of tabs from the column to the item represented.
    let numberOfTabs: UInt64

    /// The number of spaces from the column to the item represented.
    let numberOfSpaces: UInt64
}

/// The set of tokens that the lexer is able to parse.
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

/// The representation the token returned by the lexer.
public struct Token {

    /// The type of token that was found.
    public let type: TokenType

    /// The text value that makes up the token.
    public let text: String

    /// The position in the file of the token.
    public let position: FilePosition
}

class Stream {
    private var generator: IndexingGenerator<String>
    private var characters: [Character] = []
    private var index: Int = 0
    private var eof: Bool = false

    init(content: String) {
        generator = content.generate()
    }

    func prev(offset: Int = 1) -> Character? {
        assert(offset > 0)
        if index < offset { return nil }
        return characters[index - offset]
    }

    func next(offset: Int = 1) -> Character? {
        let c = peek(offset: offset)
        index = min(index + offset, characters.count)
        return c
    }

    func peek(offset: Int = 1) -> Character? {
        assert(offset > 0)
        if eof { return nil }

        if index + offset < characters.count {
            return characters[index + offset]
        }

        let remaining = characters.count - index - offset

        var c: Character? = nil
        for idx in 0..<remaining {
            c = generator.next()
            if let c = c {
                characters.append(c)
            }
            else {
                eof = true
                return nil
            }
        }

        return c
    }

    func curr() -> Character? {
        if eof { return nil }
        return characters[index]
    }
}

/// Used to create the tokens from a given piece of code.
public class Lexer : SequenceType
{
    private let tabSize = 4

    private let content: String
    private var enumerator: IndexingGenerator<String>
    private var previousChar: Character? = nil

    private var previousToken: Token? = nil

    private var lineNumber: UInt64 = 1
    private var numberOfSpaces: UInt64 = 0
    private var numberOfTabs: UInt64 = 0

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
                return Token(type: .EndOfFile, text: "", position: self.filePosition())
            }

            var value = ""

            if self.previousChar == "\n" {
                self.next()
                while self.previousChar == " " || self.previousChar == "\t" {
                    value += "\(self.previousChar!)"
                    self.next()
                }

                if countElements(value) != 0 {
                    return Token(type: .Indent, text: value, position: self.filePosition())
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
                return Token(type: type, text: value, position: self.filePosition())
            }

            // todo: support look-ahead when actually needed

            if self.previousChar == ":" {
                self.next()
                return Token(type: .Colon, text: ":", position: self.filePosition())
            }

            if self.previousChar == "|" {
                self.next()
                return Token(type: .Pipe, text: "|", position: self.filePosition())
            }

            return Token(type: .Error, text: "<invalid state>", position: self.filePosition())
        }()

        return previousToken ?? Token(type: .Error, text: "<invalid state>", position: self.filePosition())
    }

    private func filePosition() -> FilePosition {
        return FilePosition(lineNumber: lineNumber, numberOfTabs: numberOfTabs, numberOfSpaces: numberOfSpaces)
    }

    private func next() {
        previousChar = self.enumerator.next()
        if previousChar == "\n" {
            lineNumber++
            numberOfSpaces = 0
            numberOfTabs = 0
        }
        else if previousChar == "\t" {
            numberOfTabs++
        }
        else if previousChar == " " {
            numberOfSpaces++
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


///
/// MARK: Lexical Information
///

/// The full set of keywords.
private let keywords = ["as", "catch", "class", "def", "elseif", "else", "enum", "for", "finally", "func", "id", "if", "in", "let", "import", "interface", "is", "namespace", "return", "try", "typedef", "unsafe", "var"]


