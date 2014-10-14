//
//  EnumRewriter.swift
//  protc
//
//  Created by David Owens II on 10/13/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

func rewriteEnumToObjC(construct: Construct) -> (header: String, implementation: String)
{
    // todo: support the three types of enums: basic, associated value, raw value

    let basicEnum = construct as? Enum
    if let basicEnum = basicEnum {
        return rewriteEnumToObjC(basicEnum)
    }
    else {
        return ("", "")
    }
}

private func rewriteEnumToObjC(value: Enum) -> (header: String, implementation: String)
{
    var header = "@interface \(value.identifier) : NSObject\n\n"

    var implementation = "#include \"\(value.identifier).h\"\n\n"
    implementation += "#define RETURN_ENUM_INSTANCE() \\\n"
    implementation += "    static \(value.identifier) *instance = nil;\\\n"
    implementation += "    static dispatch_once_t onceToken;\\\n"
    implementation += "    dispatch_once(&onceToken, ^{\\\n"
    implementation += "        instance = [[\(value.identifier) alloc] init];\\\n"
    implementation += "    });\\\n"
    implementation += "    return instance;\n\n"

    implementation += "@implementation \(value.identifier)\n\n"

    for option in value.options {
        header += "+ (\(value.identifier) *)\(option.name);\n"
        implementation += "+ (\(value.identifier) *)\(option.name) { RETURN_ENUM_INSTANCE(); }\n"
    }

    header += "\n+ (NSArray *)values;\n"
    implementation += "\n+ (NSArray *)values\n"
    implementation += "{\n"
    implementation += "    static NSArray *values = nil;\n"
    implementation += "    static dispatch_once_t onceToken;\n"
    implementation += "    dispatch_once(&onceToken, ^{\n"
    implementation += "        values = @[ CompassPoint.North, CompassPoint.South, CompassPoint.East, CompassPoint.West ];\n"
    implementation += "    });\n\n"
    implementation += "    return values;\n"
    implementation += "}\n"

    header += "\n@end\n"
    implementation += "\n@end\n"

    return (header, implementation)
}

private func rewriteRawValueEnumToObjC(construct: Construct) -> (header: String, implementation: String)
{
    return ("", "")
}

private func rewriteAssociatedValueEnumToObjC(construct: Construct) -> (header: String, implementation: String)
{
    return ("", "")
}
