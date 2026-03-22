//
//  DiscussionListView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct DiscussionListView: View {
    @Binding var selectedDiscussion: SDDiscussion?

    let discussions: [SDDiscussion]
    var onCreateDiscussion: () -> Void
    var onDeleteDiscussion: (SDDiscussion) -> Void

    var body: some View {
        Group {
            if discussions.isEmpty {
                emptyState
            } else {
                discussionList
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    onCreateDiscussion()
                } label: {
                    Label("New Discussion", systemImage: "square.and.pencil")
                }
            }
        }
    }

    private var discussionList: some View {
        List(discussions, selection: $selectedDiscussion) { discussion in
            NavigationLink(value: discussion) {
                DiscussionRowView(discussion: discussion)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    onDeleteDiscussion(discussion)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Conversations", systemImage: "bubble.left")
        } description: {
            Text("Start chatting with this provider.")
        } actions: {
            Button("Start a new conversation", systemImage: "plus") {
                onCreateDiscussion()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
