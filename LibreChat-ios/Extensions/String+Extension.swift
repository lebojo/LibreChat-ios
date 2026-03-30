//
//  String+Extension.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 30.03.2026.
//

import Foundation

extension String {
    var markdown: AttributedString {
        (try? AttributedString(markdown: self, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? AttributedString(self)
    }
}
