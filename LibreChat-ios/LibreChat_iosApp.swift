//
//  LibreChat_iosApp.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 19.10.2025.
//

import SwiftUI
import SwiftData

@main
struct LibreChat_iosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [SDProvider.self, SDDiscussion.self, SDMessage.self])
    }
}
