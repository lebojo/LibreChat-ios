//
//  Discussion.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 29.10.2025.
//

import Foundation
import FoundationModels

struct Discussion: Identifiable, Hashable {
    var id: UUID
    var messages: [Message]
    var shortDescription: String?
    
    init(
        id: UUID = UUID(),
        messages: [Message] = [],
        shortDescription: String? = nil,
    ) {
        self.id = id
        self.messages = messages
        self.shortDescription = shortDescription
    }
}
