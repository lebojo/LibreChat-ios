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

    var body: some View {
        List(selection: $selectedProvider) {
            ForEach(providers) { provider in
                Section {
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
                } header: {
                    Text(provider.name)
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
