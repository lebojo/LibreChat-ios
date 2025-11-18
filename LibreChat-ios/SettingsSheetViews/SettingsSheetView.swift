//
//  SettingsSheetView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 07.11.2025.
//

import SwiftUI

struct SettingsSheetView: View {
    @AppStorage("FoundationModelInstructions") private var modelInstructions: String = "You are a AI assistant"

    var body: some View {
        NavigationStack {
            List {
                VStack(alignment: .leading) {
                    Text("Foundation model start instructions")
                        .bold()

                    TextEditor(text: $modelInstructions)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsSheetView()
}
