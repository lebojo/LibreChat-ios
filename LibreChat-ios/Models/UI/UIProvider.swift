//
//  UIProvider.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation

struct UIProvider: Identifiable, Hashable {
    let id: UUID
    let name: String
    let baseURL: String
    let bearerToken: String
    let modelName: String
    let isBuiltIn: Bool

    init(from provider: SDProvider) {
        self.id = provider.id
        self.name = provider.name
        self.baseURL = provider.baseURL
        self.bearerToken = provider.bearerToken
        self.modelName = provider.modelName
        self.isBuiltIn = provider.isBuiltIn
    }
}
