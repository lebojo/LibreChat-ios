//
//  Message.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 29.10.2025.
//

import Foundation

struct Message: Identifiable, Hashable {
    let id: UUID = UUID()
    let role: Role
    let text: String
    
    enum Role {
        case user
        case agent
    }
}
