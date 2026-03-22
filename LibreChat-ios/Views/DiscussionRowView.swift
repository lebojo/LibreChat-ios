//
//  DiscussionRowView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct DiscussionRowView: View {
    let discussion: SDDiscussion

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(discussion.title.isEmpty ? "New conversation" : discussion.title)
                .lineLimit(1)
            Text(discussion.updatedAt, style: .relative)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}
