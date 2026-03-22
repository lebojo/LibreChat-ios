//
//  UIDiscussion.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation

struct UIDiscussion: Identifiable, Hashable {
    let id: UUID
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let messages: [UIMessage]
    let provider: UIProvider?

    init(from discussion: SDDiscussion) {
        self.id = discussion.id
        self.title = discussion.title
        self.createdAt = discussion.createdAt
        self.updatedAt = discussion.updatedAt
        self.messages = (discussion.messages ?? [])
            .sorted { $0.createdAt < $1.createdAt }
            .map { UIMessage(from: $0) }
        self.provider = discussion.provider.map { UIProvider(from: $0) }
    }
}
