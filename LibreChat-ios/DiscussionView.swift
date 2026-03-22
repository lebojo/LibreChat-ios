//
//  DiscussionView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI
import SwiftData
import FoundationModels

struct DiscussionView: View {
    @Bindable var discussion: SDDiscussion
    @Environment(\.modelContext) private var modelContext

    @State private var messageToSend = ""
    @State private var streamingText = ""
    @State private var isGenerating = false
    @State private var session: LanguageModelSession?
    @State private var errorMessage: String?

    private var sortedMessages: [SDMessage] {
        (discussion.messages ?? []).sorted { $0.createdAt < $1.createdAt }
    }

    var body: some View {
        MessageListView(
            messages: sortedMessages,
            streamingText: streamingText
        )
        .navigationTitle(discussion.title.isEmpty ? "New conversation" : discussion.title)
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ComposeBar(
            messageToSend: $messageToSend,
            isGenerating: isGenerating,
            onSend: sendMessage
        ))
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    // MARK: - Sending

    private func sendMessage() {
        let text = messageToSend.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        let userMessage = SDMessage(role: "user", text: text, discussion: discussion)
        discussion.messages = (discussion.messages ?? []) + [userMessage]
        discussion.updatedAt = .now
        messageToSend = ""
        isGenerating = true

        Task {
            if discussion.provider?.isBuiltIn == true {
                await sendToAppleIntelligence(text: text)
            } else if let provider = discussion.provider {
                await sendToOpenAI(text: text, provider: provider)
            }
            isGenerating = false

            if discussion.title.isEmpty && (discussion.messages ?? []).count >= 2 {
                await generateTitle()
            }
        }
    }

    private func sendToAppleIntelligence(text: String) async {
        if session == nil {
            session = LanguageModelSession(model: .default)
        }
        do {
            var fullResponse = ""
            for try await chunk in session!.streamResponse(to: text) {
                fullResponse = chunk.content
                streamingText = fullResponse
            }
            let assistantMessage = SDMessage(role: "assistant", text: fullResponse, discussion: discussion)
            discussion.messages = (discussion.messages ?? []) + [assistantMessage]
            streamingText = ""
        } catch {
            errorMessage = error.localizedDescription
            streamingText = ""
        }
    }

    private func sendToOpenAI(text: String, provider: SDProvider) async {
        let chatMessages = sortedMessages.map {
            OpenAIService.ChatMessage(
                role: $0.role == "user" ? "user" : "assistant",
                content: $0.text
            )
        }

        var fullResponse = ""
        do {
            for try await chunk in OpenAIService.streamChat(
                baseURL: provider.baseURL,
                bearerToken: provider.bearerToken,
                model: provider.modelName,
                messages: chatMessages
            ) {
                fullResponse += chunk
                streamingText = fullResponse
            }
            let assistantMessage = SDMessage(role: "assistant", text: fullResponse, discussion: discussion)
            discussion.messages = (discussion.messages ?? []) + [assistantMessage]
            streamingText = ""
        } catch {
            errorMessage = error.localizedDescription
            streamingText = ""
        }
    }

    // MARK: - Title Generation

    private func generateTitle() async {
        let conversation = sortedMessages
            .prefix(4)
            .map { "\($0.role): \($0.text)" }
            .joined(separator: "\n")

        let titleSession = LanguageModelSession(model: .default)
        do {
            let response = try await titleSession.respond(
                to: "Generate a very short title (max 5 words) for this conversation. Reply with ONLY the title, nothing else.\n\n\(conversation)"
            )
            discussion.title = String(describing: response.content)
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            if let first = sortedMessages.first {
                discussion.title = String(first.text.prefix(30))
            }
        }
    }
}
