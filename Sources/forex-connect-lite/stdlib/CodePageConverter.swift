//
//  CodePageConverter.swift
//  
//
//  Created by Nikolai Borovennikov on 05.07.2022.
//

import Foundation

enum CodePageConverterError: Error {
    case unsupportedCodepage
}

extension String.Encoding {

    init(codepage: Int) throws {
        switch codepage {
        case Io.CP_ANSI:
            self = .ascii
//        case Io.CP_UTF7:
//            return .utf7
        case Io.CP_UTF8:
            self = .utf8
        default:
            throw CodePageConverterError.unsupportedCodepage
        }
    }

}
