//
//  ProviderTemplatePicker.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct ProviderTemplatePicker: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTemplate: ProviderTemplate?

    var body: some View {
        NavigationStack {
            List {
                Section("Popular providers") {
                    ForEach(ProviderTemplate.known) { template in
                        NavigationLink(value: template) {
                            Label(template.name, systemImage: template.icon)
                        }
                    }
                }

                Section {
                    NavigationLink(value: ProviderTemplate.custom) {
                        Label("Custom Host", systemImage: "server.rack")
                    }
                }
            }
            .navigationTitle("New Provider")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .navigationDestination(for: ProviderTemplate.self) { template in
                AddProviderSheet(template: template)
            }
        }
    }
}
