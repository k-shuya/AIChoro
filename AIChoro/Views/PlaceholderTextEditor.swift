//
//  PlaceholderTextEditor.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/23.
//

import SwiftUI

struct PlaceholderTextEditor: View {
    var placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(5)
                .scrollContentBackground(.hidden)
                .background(.ultraLightPrimary, in: RoundedRectangle(cornerRadius: 10))
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(EdgeInsets(top: 8, leading: 4, bottom: 0, trailing: 0))
            }
        }
    }
}
