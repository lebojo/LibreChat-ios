//
//  SDMessage.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation
import SwiftData

@Model
final class SDMessage {
    var id: UUID = UUID()
    var role: String = ""
    var text: String = ""
    var createdAt: Date = Date.now
    var discussion: SDDiscussion?

    init(
        id: UUID = UUID(),
        role: String,
        text: String,
        createdAt: Date = .now,
        discussion: SDDiscussion? = nil
    ) {
        self.id = id
        self.role = role
        self.text = text
        self.createdAt = createdAt
        self.discussion = discussion
    }
}
