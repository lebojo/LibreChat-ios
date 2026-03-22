//
//  AddProviderSheet.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI
import SwiftData

struct AddProviderSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var existingProviders: [SDProvider]

    @State private var name: String
    @State private var baseURLTemplate: String
    @State private var productId = ""
    @State private var bearerToken = ""
    @State private var modelName = ""
    @State private var availableModels: [String] = []
    @State private var isFetchingModels = false
    @State private var fetchError: String?

    let template: ProviderTemplate

    init(template: ProviderTemplate) {
        self.template = template
        _name = State(initialValue: template.name == "Custom Host" ? "" : template.name)
        _baseURLTemplate = State(initialValue: template.baseURL)
    }

    private var matchingProvider: SDProvider? {
        existingProviders.first {
            !$0.isBuiltIn && !$0.bearerToken.isEmpty && $0.name == template.name
        }
    }

    private var resolvedBaseURL: String {
        if template.requiresProductId {
            return baseURLTemplate.replacingOccurrences(of: "{product_id}", with: productId)
        }
        return baseURLTemplate
    }

    private var canFetchModels: Bool {
        !resolvedBaseURL.isEmpty && !bearerToken.isEmpty
            && (!template.requiresProductId || !productId.isEmpty)
    }

    private var isConnectionComplete: Bool {
        canFetchModels
    }

    var body: some View {
        Form {
            Section("Provider") {
                TextField("Name", text: $name)
            }

            Section("Connection") {
                if let existing = matchingProvider {
                    Button {
                        baseURLTemplate = existing.baseURL
                        bearerToken = existing.bearerToken
                        resetModels()
                    } label: {
                        Label("Copy info from \(existing.name)", systemImage: "doc.on.doc")
                    }
                }
                if template.requiresProductId {
                    TextField("Product ID", text: $productId)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: productId) {
                            resetModels()
                        }
                }
                if !template.hasFixedURL {
                    TextField("Base URL", text: $baseURLTemplate)
                        .textContentType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                SecureField("Bearer Token", text: $bearerToken)
                    .onChange(of: bearerToken) {
                        resetModels()
                    }
            }

            if isConnectionComplete {
                Section("Model") {
                    if availableModels.isEmpty {
                        HStack {
                            TextField("Model name", text: $modelName)
                            Button {
                                fetchModels()
                            } label: {
                                if isFetchingModels {
                                    ProgressView()
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                }
                            }
                            .disabled(isFetchingModels)
                        }
                    } else {
                        Picker("Model", selection: $modelName) {
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

            Section {
                Text("The provider must support the OpenAI chat completions API format.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Add \(template.name == "Custom Host" ? "Provider" : template.name)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    let provider = SDProvider(
                        name: name,
                        baseURL: resolvedBaseURL,
                        bearerToken: bearerToken,
                        modelName: modelName,
                        authStyle: template.authStyle.rawValue
                    )
                    modelContext.insert(provider)
                    dismiss()
                }
                .disabled(name.isEmpty || resolvedBaseURL.isEmpty || bearerToken.isEmpty || modelName.isEmpty)
            }
        }
    }

    private func resetModels() {
        availableModels = []
        modelName = ""
        fetchError = nil
    }

    private func fetchModels() {
        isFetchingModels = true
        fetchError = nil
        Task {
            do {
                let models = try await OpenAIService.fetchModels(
                    baseURL: resolvedBaseURL,
                    bearerToken: bearerToken,
                    authStyle: template.authStyle.rawValue
                )
                availableModels = models
                if !models.isEmpty && (modelName.isEmpty || !models.contains(modelName)) {
                    modelName = models.first ?? ""
                }
            } catch {
                fetchError = "Could not fetch models."
            }
            isFetchingModels = false
        }
    }
}
