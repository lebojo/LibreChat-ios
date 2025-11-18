//
//  ContentView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 19.10.2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var discussions: [Discussion] = []
    @State private var currentDiscussion: Discussion?

    var body: some View {
        NavigationSplitView {
            if !discussions.isEmpty {
                List(discussions, id: \.id, selection: $currentDiscussion) { discussion in
                    NavigationLink(discussion.shortDescription ?? "Empty conv", value: discussion)
                }
            } else {
                VStack {
                    Text("**Hey**,\nlooks like it's your first time here!")
                        .padding()
                    Button("Create a new discussion", systemImage: "plus") {
                        discussions.append(Discussion())
                        currentDiscussion = discussions.last
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        } content: {
            if currentDiscussion != nil {
                DiscussionView(
                    discussion: Binding(
                        get: { currentDiscussion! },
                        set: { currentDiscussion = $0 }
                    )
                )
            } else {
                EmptyView()
            }
        } detail: {
        }
    }
}

#Preview {
    ContentView()
}
