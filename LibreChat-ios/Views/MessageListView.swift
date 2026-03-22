//
//  MessageListView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct MessageListView: View {
    let messages: [SDMessage]
    let streamingText: String

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if messages.isEmpty && streamingText.isEmpty {
                    emptyState
                } else {
                    ForEach(messages) { message in
                        MessageBubble(message: UIMessage(from: message))
                    }
                    if !streamingText.isEmpty {
                        StreamingBubble(text: streamingText)
                    }
                }
            }
            .padding(.vertical)
        }
        .defaultScrollAnchor(.bottom)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Spacer()
                .frame(height: 100)
            Text("**Hey**,\nI'm here to help you")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
