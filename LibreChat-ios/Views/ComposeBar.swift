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
        #if !os(visionOS)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                TextField("Enter a message", text: $messageToSend, axis: .vertical)
                    .lineLimit(1 ... 5)
                    .disabled(isGenerating)
            }

            ToolbarSpacer(.flexible, placement: .bottomBar)

            ToolbarItem(placement: .bottomBar) {
                Button("Send", systemImage: "paperplane.fill") {
                    onSend()
                }
                .disabled(!canSend)
                .keyboardShortcut(.defaultAction)
            }
        }
        #else
        .safeAreaInset(edge: .bottom) {
                TextField("Enter a message", text: $messageToSend, axis: .vertical)
                    .lineLimit(1 ... 5)
                    .disabled(isGenerating)

                Spacer()

                Button("Send", systemImage: "paperplane.fill") {
                    onSend()
                }
                .disabled(!canSend)
                .keyboardShortcut(.defaultAction)
            }
        #endif
    }
}
