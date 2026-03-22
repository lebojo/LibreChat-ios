//
//  MessageBubble.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct MessageBubble: View {
    let message: UIMessage

    private var isUser: Bool { message.role == .user }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 60) }
            Text(message.text)
                .padding(12)
                .background(
                    isUser ? AnyShapeStyle(.tint) : AnyShapeStyle(.fill.tertiary),
                    in: .rect(cornerRadius: 16)
                )
                .foregroundStyle(isUser ? .white : .primary)
            if !isUser { Spacer(minLength: 60) }
        }
        .padding(.horizontal)
    }
}
