//
//  FlexibleTextView.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/14.
//

import SwiftUI

struct FlexibleTextView: View {
    enum LayoutSize: CGFloat {
        case baseHeight = 60
        case lineHeight = 16
        case maxLines = 4
    }
    
    @State var inputText = ""
    @State private var height: CGFloat = LayoutSize.baseHeight.rawValue
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "apple.intelligence")
            TextField(
                "質問を入力",
                text: $inputText,
                axis: .vertical
            )
            .focused($isFocused)
            .lineLimit(1...Int(LayoutSize.maxLines.rawValue))
            .font(.system(size: LayoutSize.lineHeight.rawValue))
            .textFieldStyle(.plain)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
        .onChange(of: inputText) {
            adjustHeight()
        }
    }
    
    private func adjustHeight() {
        let lines = min(
            CGFloat(inputText.components(separatedBy: .newlines).count),
            LayoutSize.maxLines.rawValue
        )
        height = LayoutSize.baseHeight.rawValue + (lines - 1) * LayoutSize.lineHeight.rawValue
    }
}
