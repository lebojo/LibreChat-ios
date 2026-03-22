//
//  ContentView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 19.10.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SDProvider.name) private var providers: [SDProvider]
    @Query(sort: \SDDiscussion.updatedAt, order: .reverse) private var allDiscussions: [SDDiscussion]

    @State private var selectedProvider: SDProvider?
    @State private var selectedDiscussion: SDDiscussion?
    @State private var showAddProvider = false

    var body: some View {
        NavigationSplitView {
            ProviderListSidebar(
                providers: providers,
                selectedProvider: $selectedProvider,
                showAddProvider: $showAddProvider,
                onDuplicate: duplicateProvider,
                onDelete: deleteProvider
            )
        } content: {
            if let selectedProvider {
                DiscussionListView(
                    discussions: allDiscussions.filter { $0.provider?.id == selectedProvider.id },
                    selectedDiscussion: $selectedDiscussion,
                    onCreateDiscussion: { createDiscussion(for: selectedProvider) },
                    onDeleteDiscussion: deleteDiscussion
                )
                .navigationTitle(selectedProvider.name)
            } else {
                ContentUnavailableView(
                    "No Provider Selected",
                    systemImage: "server.rack",
                    description: Text("Select a provider to see its discussions.")
                )
            }
        } detail: {
            if let selectedDiscussion {
                DiscussionView(discussion: selectedDiscussion)
            } else {
                ContentUnavailableView(
                    "No Discussion Selected",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Select a discussion or create a new one.")
                )
            }
        }
        .task {
            ensureAppleIntelligenceProvider()
        }
    }

    private func ensureAppleIntelligenceProvider() {
        let builtInProviders = providers.filter { $0.isBuiltIn }

        if builtInProviders.isEmpty {
            let provider = SDProvider(name: "Apple Intelligence", isBuiltIn: true)
            modelContext.insert(provider)
            return
        }

        // Merge duplicates created by CloudKit sync across devices
        guard builtInProviders.count > 1 else { return }

        let primary = builtInProviders[0]
        for duplicate in builtInProviders.dropFirst() {
            for discussion in duplicate.discussions ?? [] {
                discussion.provider = primary
            }
            modelContext.delete(duplicate)
        }

        if selectedProvider?.isBuiltIn == true {
            selectedProvider = primary
        }
    }

    private func createDiscussion(for provider: SDProvider) {
        let discussion = SDDiscussion(provider: provider)
        modelContext.insert(discussion)
        selectedDiscussion = discussion
    }

    private func deleteDiscussion(_ discussion: SDDiscussion) {
        if selectedDiscussion?.id == discussion.id {
            selectedDiscussion = nil
        }
        modelContext.delete(discussion)
    }

    private func duplicateProvider(_ provider: SDProvider) {
        let duplicate = SDProvider(
            name: provider.name,
            baseURL: provider.baseURL,
            bearerToken: provider.bearerToken,
            modelName: provider.modelName,
            authStyle: provider.authStyle
        )
        modelContext.insert(duplicate)
    }

    private func deleteProvider(_ provider: SDProvider) {
        if selectedProvider?.id == provider.id {
            selectedProvider = nil
        }
        modelContext.delete(provider)
    }
}
