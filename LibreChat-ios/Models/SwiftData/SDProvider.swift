//
//  SDProvider.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation
import SwiftData

@Model
final class SDProvider {
    var id: UUID = UUID()
    var name: String = ""
    var baseURL: String = ""
    var bearerToken: String = ""
    var modelName: String = ""
    var authStyle: String = "bearer"
    var isBuiltIn: Bool = false
    @Relationship(deleteRule: .cascade, inverse: \SDDiscussion.provider)
    var discussions: [SDDiscussion]?

    init(
        id: UUID = UUID(),
        name: String,
        baseURL: String = "",
        bearerToken: String = "",
        modelName: String = "",
        authStyle: String = "bearer",
        isBuiltIn: Bool = false
    ) {
        self.id = id
        self.name = name
        self.baseURL = baseURL
        self.bearerToken = bearerToken
        self.modelName = modelName
        self.authStyle = authStyle
        self.isBuiltIn = isBuiltIn
        self.discussions = nil
    }
}
