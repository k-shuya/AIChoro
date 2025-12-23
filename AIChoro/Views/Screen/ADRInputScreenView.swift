//
//  ADRInputScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/23.
//

import SwiftUI

struct ADRInputScreenView: View {
    var adr: ADR?
    @State private var status: String = ""
    @State private var decision: String = ""
    @State private var context: String = ""
    @State private var others: String = ""
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            contentView
                .background(Color(.systemGroupedBackground))
                .onTapGesture { isFocused = false }
        }
    }
    
    var contentView: some View {
        VStack(spacing: 24) {
            Group {
                VStack(alignment: .leading, spacing: 24) {
                    pickerSectionView(
                        title: "ステータス",
                        placeholder: "提案/承認/却下/取下",
                        valueState: $status
                    )
                    sectionView(
                        title: "決定内容",
                        placeholder: "今日の晩御飯はカレーにする",
                        valueState: $decision
                    )
                    sectionView(
                        title: "背景・理由",
                        placeholder: "インスタを見て食べたくなったから",
                        valueState: $context
                    )
                    sectionView(
                        title: "その他",
                        placeholder: "食材の買い出しが必要",
                        valueState: $others,
                        shouldMultiLine: true
                    )
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(Color(.white))
            .cornerRadius(24)
            
            Button {
                
            } label: {
                Text("保存")
            }
            .accentColor(.white)
            .buttonStyle(ScaleButtonStyle())
//            .frame(maxWidth: .infinity, minHeight: 52)
            
            Spacer()
        }
        .padding(16)
    }
    
    private func sectionView(title: String, placeholder: String, valueState: Binding<String>, shouldMultiLine: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primaryGray)
            if shouldMultiLine {
                TextField(
                    placeholder,
                    text: valueState,
                    axis: .vertical
                )
                .focused($isFocused)
                .font(.system(size: 16))
                .lineLimit(4...)
                .textFieldStyle(.plain)
                .padding(6)
                .background(.ultraLightPrimary, in: RoundedRectangle.rect(cornerRadius: 6))
            } else {
                TextField(
                    placeholder,
                    text: valueState,
                )
                .focused($isFocused)
                .font(.system(size: 16))
                .textFieldStyle(.plain)
                .padding(6)
                .background(.ultraLightPrimary, in: RoundedRectangle.rect(cornerRadius: 6))
            }
        }
    }
    
    private func pickerSectionView(title: String, placeholder: String, valueState: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primaryGray)
            Menu {
                Picker(selection: $status, label: EmptyView()) {
                    ForEach(ADRStatus.allCases, id: \.title) { status in
                        Text(status.title)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
            } label: {
                HStack {
                    if status.isEmpty {
                        Text("提案/承認/却下/取下")
                    } else {
                        Text(status)
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 16))
                }
                .padding(6)
                .font(.system(size: 16))
                .foregroundStyle(
                    status.isEmpty
                    ? .gray.opacity(0.5)
                    : .ultraDarkPrimary
                )
                .onAppear {
                    print(status)
                }
            }
            .background(.ultraLightPrimary)
            .frame(width: 200, height: 34)
            .cornerRadius(8)
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .padding()
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, minHeight: 52)
        .background(Color(.primary))
        .cornerRadius(.infinity)
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

#Preview {
    let adr = ADR(
        status: .approved,
        decision: "今日の晩御飯はカレーにする",
        context: "Instagramで流れてきたから",
        others: "食材の買い出しが必要"
    )
    ADRInputScreenView(adr: adr)
}
