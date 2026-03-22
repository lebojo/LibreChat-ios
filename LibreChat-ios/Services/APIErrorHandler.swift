//
//  APIErrorHandler.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation

struct APIError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

enum APIErrorHandler {

    static func parseErrorMessage(from body: String) -> String? {
        guard let data = body.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        // OpenAI / Anthropic format: { "error": { "message": "..." } }
        if let error = json["error"] as? [String: Any],
           let message = error["message"] as? String {
            return message
        }
        // Fallback: { "error": { "type": "..." } }
        if let error = json["error"] as? [String: Any],
           let type = error["type"] as? String {
            return type
        }
        // Simple format: { "message": "..." }
        if let message = json["message"] as? String {
            return message
        }
        return nil
    }

    static func error(from body: String, statusCode: Int) -> APIError {
        let message = parseErrorMessage(from: body) ?? "HTTP \(statusCode)"
        return APIError(message: message)
    }
}
