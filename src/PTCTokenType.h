//
//  PTCTokenType.h
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PTCTokenType) {
    PTCTokenTypeError,
    PTCTokenTypeIdentifier,
    PTCTokenTypeKeyword,
    PTCTokenTypeIndent,
    PTCTokenTypeNewLine,
    PTCTokenTypeColon,
    PTCTokenTypePipe,
    PTCTokenTypeOperator,
    PTCTokenTypeEndOfFile
};
