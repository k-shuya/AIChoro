//
//  ADREditScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/24.
//

import SwiftUI
import SwiftData

struct ADREditScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.adrListRouter) var adrListRouter
    
    @Bindable var adr: ADR
    
    @State private var isShowValidation = false
    @State private var validationMessage: String = ""
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            contentView
                .background(Color(.ultraLightPrimary))
                .onTapGesture { isFocused = false }
                .toolbar(.hidden, for: .tabBar)
        }
    }
    
    var contentView: some View {
        VStack(spacing: 24) {
            Group {
                VStack(alignment: .leading, spacing: 24) {
                    statusSectionView(
                        title: "ステータス",
                        placeholder: "提案/承認/却下/取下",
                        valueState: $adr.status
                    )
                    sectionView(
                        title: "決定内容",
                        placeholder: "今日の晩御飯はカレーにする",
                        valueState: $adr.decision
                    )
                    sectionView(
                        title: "背景・理由",
                        placeholder: "インスタを見て食べたくなったから",
                        valueState: $adr.context,
                        shouldMultiLine: true
                    )
                    sectionView(
                        title: "その他",
                        placeholder: "食材の買い出しが必要",
                        valueState: $adr.others,
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
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            if isShowValidation {
                Text("\(Image(systemName: "exclamationmark.triangle")) \(validationMessage)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.ultraDarkPrimary)
            }
            
            Button {
                if validate() {
                    Task {
                        await adr.reVectrize()
                    }
                    adrListRouter.pop()
                } else {
                    isShowValidation = true
                }
            } label: {
                Text("保存")
            }
            .padding(.horizontal, 24)
            .accentColor(.white)
            .buttonStyle(ScaleButtonStyle())
            
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
    
    private func statusSectionView(title: String, placeholder: String, valueState: Binding<ADRStatus>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primaryGray)
            Menu {
                Picker(selection: valueState, label: EmptyView()) {
                    ForEach(ADRStatus.allCases, id: \.self) { status in
                        Text(status.title).tag(ADRStatus?.some(status))
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
            } label: {
                HStack {
                    Text(valueState.wrappedValue.title)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 16))
                }
                .padding(6)
                .font(.system(size: 16))
                .foregroundStyle(.ultraDarkPrimary)
            }
            .background(.ultraLightPrimary)
            .frame(width: 200, height: 34)
            .cornerRadius(8)
        }
    }
    
    private func validate() -> Bool {
        var result = true
        var emptySections: [String] = []
        
        if adr.decision.isEmpty {
            emptySections.append("決定内容")
            result = false
        }
        if adr.context.isEmpty {
            emptySections.append("背景・理由")
            result = false
        }
        if !emptySections.isEmpty {
            validationMessage = emptySections.joined(separator: ", ") + "を入力してください"
        }
        return result
    }
}
