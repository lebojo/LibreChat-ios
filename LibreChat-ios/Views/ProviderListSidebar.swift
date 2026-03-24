//
//  ProviderListSidebar.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct ProviderListSidebar: View {
    @State private var providerToEdit: SDProvider?

    @Binding var selectedProvider: SDProvider?
    @Binding var showAddProvider: Bool

    let providers: [SDProvider]
    var onDuplicate: (SDProvider) -> Void
    var onDelete: (SDProvider) -> Void

    private var groupedProviders: [(name: String, providers: [SDProvider])] {
        var seen: [String: Int] = [:]
        var groups: [(name: String, providers: [SDProvider])] = []
        for provider in providers {
            if let index = seen[provider.name] {
                groups[index].providers.append(provider)
            } else {
                seen[provider.name] = groups.count
                groups.append((name: provider.name, providers: [provider]))
            }
        }
        return groups
    }

    var body: some View {
        List(selection: $selectedProvider) {
            ForEach(groupedProviders, id: \.name) { group in
                Section {
                    ForEach(group.providers) { provider in
                        NavigationLink(value: provider) {
                            ProviderRowView(
                                provider: provider,
                                displayName: provider.isBuiltIn ? "Apple Intelligence" : provider.modelName
                            )
                        }
                        .contextMenu {
                            if !provider.isBuiltIn {
                                Button {
                                    onDuplicate(provider)
                                } label: {
                                    Label("Duplicate", systemImage: "plus.square.on.square")
                                }
                                Button(role: .destructive) {
                                    onDelete(provider)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                } header: {
                    Text(group.name)
                }
            }
        }
        .navigationTitle("Providers")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddProvider = true
                } label: {
                    Label("Add a Provider", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddProvider) {
            ProviderTemplatePicker()
        }
    }
}
