//
//  UIMessage.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation

struct UIMessage: Identifiable, Hashable {
    let id: UUID
    let role: Role
    let text: String
    let createdAt: Date

    enum Role: String {
        case user
        case assistant
    }

    init(from message: SDMessage) {
        self.id = message.id
        self.role = Role(rawValue: message.role) ?? .user
        self.text = message.text
        self.createdAt = message.createdAt
    }
}
