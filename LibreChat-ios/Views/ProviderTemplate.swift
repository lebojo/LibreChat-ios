//
//  ProviderTemplate.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation

enum ProviderAuthStyle: String, Codable, Hashable {
    case bearer
    case anthropic
}

struct ProviderTemplate: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let baseURL: String
    var requiresProductId: Bool = false
    var authStyle: ProviderAuthStyle = .bearer

    var hasFixedURL: Bool {
        !baseURL.isEmpty
    }

    static let known: [ProviderTemplate] = [
        ProviderTemplate(
            name: "OpenAI",
            icon: "brain",
            baseURL: "https://api.openai.com/v1"
        ),
        ProviderTemplate(
            name: "Gemini",
            icon: "sparkles",
            baseURL: "https://generativelanguage.googleapis.com/v1beta/openai"
        ),
        ProviderTemplate(
            name: "Claude",
            icon: "cloud",
            baseURL: "https://api.anthropic.com/v1",
            authStyle: .anthropic
        ),
        ProviderTemplate(
            name: "Infomaniak",
            icon: "globe.europe.africa.fill",
            baseURL: "https://api.infomaniak.com/2/ai/{product_id}/openai/v1",
            requiresProductId: true
        ),
    ]

    static let custom = ProviderTemplate(
        name: "Custom Host",
        icon: "server.rack",
        baseURL: ""
    )
}
