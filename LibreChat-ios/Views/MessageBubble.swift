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
        if isUser {
            Text(message.text.markdown)
                .padding()
                .background(
                    AnyShapeStyle(.tint),
                    in: .rect(cornerRadius: 16)
                )
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
        } else {
            Text(message.text.markdown)
        }
    }
}

#Preview {
    MessageBubble(message: UIMessage(from: SDMessage(id: UUID(), role: "user", text: "je suis un test je suis un test je suis un test je suis un test", createdAt: .now , discussion: nil)))
}
