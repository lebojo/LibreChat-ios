//
//  MessageListView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct MessageListView: View {
    let messages: [UIMessage]
    let streamingText: String

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if messages.isEmpty && streamingText.isEmpty {
                    emptyState
                } else {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                    if !streamingText.isEmpty {
                        Text(streamingText.markdown)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .defaultScrollAnchor(.bottom)
        .animation(.default, value: streamingText)
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
