//
//  SDDiscussion.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation
import SwiftData

@Model
final class SDDiscussion {
    var id: UUID = UUID()
    var title: String = ""
    var createdAt: Date = Date.now
    var updatedAt: Date = Date.now
    var provider: SDProvider?
    @Relationship(deleteRule: .cascade, inverse: \SDMessage.discussion)
    var messages: [SDMessage]?

    init(
        id: UUID = UUID(),
        title: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now,
        provider: SDProvider? = nil
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.provider = provider
        self.messages = nil
    }
}
