//
//  ProviderRowView.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct ProviderRowView: View {
    let provider: SDProvider
    var displayName: String

    var body: some View {
        Label {
            Text(displayName)
        } icon: {
            Image(systemName: provider.isBuiltIn ? "apple.intelligence" : "server.rack")
        }
    }
}
