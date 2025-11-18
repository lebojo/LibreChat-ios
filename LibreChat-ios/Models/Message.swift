//
//  Message.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 29.10.2025.
//

import Foundation
import FoundationModels

struct Message: Identifiable, Hashable {
    let id: UUID = UUID()
    let role: Role
    var text: String
    
    enum Role {
        case user
        case agent
    }
}
