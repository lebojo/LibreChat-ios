//
//  StreamingBubble.swift
//  LibreChat-ios
//
//  Created by Jordan Chap on 18.03.2026.
//

import SwiftUI

struct StreamingBubble: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .background(.fill.tertiary, in: .rect(cornerRadius: 16))
            Spacer(minLength: 60)
        }
        .padding(.horizontal)
    }
}
