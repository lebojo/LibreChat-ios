//
//  OpenAIService.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import Foundation

enum OpenAIService {

    struct ChatMessage: Codable {
        let role: String
        let content: String
    }

    struct ChatRequest: Codable {
        let model: String
        let messages: [ChatMessage]
        let stream: Bool
    }

    struct ChatResponseChunk: Codable {
        struct Choice: Codable {
            struct Delta: Codable {
                let content: String?
            }
            let delta: Delta
        }
        let choices: [Choice]
    }

    // MARK: - Auth

    private static func applyAuth(to request: inout URLRequest, token: String, authStyle: String) {
        if authStyle == "anthropic" {
            request.setValue(token, forHTTPHeaderField: "x-api-key")
            request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        } else {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    // MARK: - Models

    struct OpenAIModelsResponse: Codable {
        struct Model: Codable {
            let id: String
        }
        let data: [Model]
    }

    struct AnthropicModelsResponse: Codable {
        struct Model: Codable {
            let id: String
        }
        let data: [Model]
    }

    static func fetchModels(baseURL: String, bearerToken: String, authStyle: String = "bearer") async throws -> [String] {
        let urlString = baseURL.trimmingCharacters(in: .init(charactersIn: "/")) + "/models"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        applyAuth(to: &request, token: bearerToken, authStyle: authStyle)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIErrorHandler.error(from: body, statusCode: httpResponse.statusCode)
        }

        // Both formats have { "data": [{ "id": "..." }] }
        let modelsResponse = try JSONDecoder().decode(OpenAIModelsResponse.self, from: data)
        return modelsResponse.data.map(\.id).sorted()
    }

    // MARK: - Chat

    static func streamChat(
        baseURL: String,
        bearerToken: String,
        model: String,
        messages: [ChatMessage]
    ) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                let urlString = baseURL.trimmingCharacters(in: .init(charactersIn: "/")) + "/chat/completions"

                guard let url = URL(string: urlString) else {
                    continuation.finish(throwing: URLError(.badURL))
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                // Chat completions always uses Bearer auth (OpenAI-compatible endpoint)
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

                let body = ChatRequest(model: model, messages: messages, stream: true)
                request.httpBody = try? JSONEncoder().encode(body)

                do {
                    let (bytes, response) = try await URLSession.shared.bytes(for: request)

                    if let httpResponse = response as? HTTPURLResponse,
                       httpResponse.statusCode != 200 {
                        // Read error body for debugging
                        var errorBody = ""
                        for try await line in bytes.lines {
                            errorBody += line
                        }
                        continuation.finish(throwing: APIErrorHandler.error(
                            from: errorBody,
                            statusCode: httpResponse.statusCode
                        ))
                        return
                    }

                    for try await line in bytes.lines {
                        guard line.hasPrefix("data: ") else { continue }
                        let payload = String(line.dropFirst(6))
                        guard payload != "[DONE]" else { break }

                        if let data = payload.data(using: .utf8),
                           let chunk = try? JSONDecoder().decode(ChatResponseChunk.self, from: data),
                           let content = chunk.choices.first?.delta.content {
                            continuation.yield(content)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

}
