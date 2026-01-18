//
//  FlexibleTextView.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/14.
//

import SwiftUI

struct FlexibleTextView: View {
    
    @Binding var messageData: MessageData
    
    @State private var inputText = ""
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            TextField(
                "質問を入力",
                text: $inputText,
                axis: .vertical
            )
            .padding(.vertical, 12)
            .focused($isFocused)
            .lineLimit(1...4)
            .font(.system(size: 16))
            .textFieldStyle(.plain)
            
            Spacer()
            
            Button {
                if !inputText.isEmpty {
                    messageData.text = inputText
                    messageData.timeStamp = Date()
                    inputText = ""
                    isFocused = false
                }
            } label: {
                Image(systemName: "paperplane")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 32, height: 32)
            .background(Color(.appPrimary))
            .clipShape(Circle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(minHeight: 60)
        .glassEffect()
    }
}
