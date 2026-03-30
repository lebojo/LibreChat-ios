//
//  ComposeBar.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct ComposeBar: ViewModifier {
    @Binding var messageToSend: String

    let isGenerating: Bool
    var onSend: () -> Void

    private var canSend: Bool {
        !messageToSend.trimmingCharacters(in: .whitespaces).isEmpty && !isGenerating
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    TextField("Enter a message", text: $messageToSend, axis: .vertical)
                        .lineLimit(1...5)
                        .disabled(isGenerating)
                }

                #if !os(visionOS)
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                #else
                    ToolbarItem(placement: .bottomBar) {
                        Spacer()
                    }
                #endif

                ToolbarItem(placement: .bottomBar) {
                    Button("Send", systemImage: "paperplane.fill") {
                        onSend()
                    }
                    .disabled(!canSend)
                }
            }
    }
}
