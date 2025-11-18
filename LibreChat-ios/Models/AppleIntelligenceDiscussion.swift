//
//  AppleIntelligenceDiscussion.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 07.11.2025.
//

import Foundation
import FoundationModels
import SwiftData

@Model
final class AppleIntelligenceDiscussion {
    @Attribute(.unique) var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var transcripts: Transcript?

    init(id: UUID, title: String, createdAt: Date, updatedAt: Date, transcripts: Transcript? = nil) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.transcripts = transcripts
    }
}
