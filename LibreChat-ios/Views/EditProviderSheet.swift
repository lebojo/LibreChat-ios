//
//  EditProviderSheet.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct EditProviderSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var availableModels: [String] = []
    @State private var isFetchingModels = false
    @State private var fetchError: String?

    @Bindable var provider: SDProvider

    var body: some View {
        NavigationStack {
            Form {
                Section("Provider") {
                    TextField("Name", text: $provider.name)
                }

                Section("Connection") {
                    TextField("Base URL", text: $provider.baseURL)
                        .textContentType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    SecureField("Bearer Token", text: $provider.bearerToken)
                        .onChange(of: provider.bearerToken) {
                            availableModels = []
                            fetchError = nil
                        }
                }

                Section("Model") {
                    if availableModels.isEmpty {
                        HStack {
                            TextField("Model name", text: $provider.modelName)
                            Button {
                                fetchModels()
                            } label: {
                                if isFetchingModels {
                                    ProgressView()
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                }
                            }
                            .disabled(provider.baseURL.isEmpty || provider.bearerToken.isEmpty || isFetchingModels)
                        }
                    } else {
                        Picker("Model", selection: $provider.modelName) {
                            ForEach(availableModels, id: \.self) { model in
                                Text(model).tag(model)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }

                    if let fetchError {
                        Text(fetchError)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Edit Provider")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func fetchModels() {
        isFetchingModels = true
        fetchError = nil
        Task {
            do {
                let models = try await OpenAIService.fetchModels(
                    baseURL: provider.baseURL,
                    bearerToken: provider.bearerToken,
                    authStyle: provider.authStyle
                )
                availableModels = models
                if !models.isEmpty && !models.contains(provider.modelName) {
                    provider.modelName = models.first ?? ""
                }
            } catch {
                fetchError = "Could not fetch models."
            }
            isFetchingModels = false
        }
    }
}
