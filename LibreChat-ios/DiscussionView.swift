//
//  DiscussionView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 29.10.2025.
//

import SwiftUI
import FoundationModels

struct DiscussionView: View {
    @Binding var discussion: Discussion
    
    @State private var messageToSend: String = ""
    @State private var messageGeneration: String = ""

    @State private var session = LanguageModelSession(model: .default, instructions: """
        Tu parles Français.
        Tu parles avec des réponses courte.
        Tu es mon ami.
        Tu me tutoie.
        Quand tu ne peux pas me répondre, tu dois m'expliquer pourquoi.
        """)
    
    var body: some View {
        List {
            if !discussion.messages.isEmpty {
                ForEach(discussion.messages) { message in
                    Text(message.text)
                        .frame(
                            maxWidth: .infinity,
                            alignment: message.role == .agent
                            ? .leading : .trailing
                        )
                }
                if !messageGeneration.isEmpty {
                    Text(messageGeneration)
                        .frame(
                            maxWidth: .infinity,
                            alignment:.leading
                        )
                }
            } else {
                Text("**Hey**,\nI'm here to help you")
                    .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                TextField("Enter a message", text: $messageToSend)
                    .padding(.horizontal)
            }

            ToolbarSpacer(.flexible, placement: .bottomBar)

            ToolbarItem(placement: .bottomBar) {
                Button("Send", systemImage: "paperplane.fill") {
                    discussion.messages.append(
                        Message(role: .user, text: messageToSend)
                    )
                    
                    Task {
                        for try await chunk in session.streamResponse(to: messageToSend) {
                            messageGeneration = chunk.content
                        }
                        
                        discussion.messages.append(
                            Message(role: .agent, text: messageGeneration)
                        )
                        
                        messageToSend = ""
                        messageGeneration = ""
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        DiscussionView(discussion: .constant(Discussion.init()))
    }
}
