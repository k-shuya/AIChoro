//
//  ADRCreateScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/23.
//

import SwiftUI
import SwiftData

struct ADRCreateScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.adrListRouter) var adrListRouter

    @State private var status: ADRStatus? = nil
    @State private var decision: String = ""
    @State private var context: String = ""
    @State private var others: String = ""
    
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
                        valueState: $context,
                        shouldMultiLine: true
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
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            if isShowValidation {
                Text("\(Image(systemName: "exclamationmark.triangle")) \(validationMessage)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.ultraDarkPrimary)
            }
            
            Button {
                if validate() {
                    insertIntoContext()
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
    
    private func statusSectionView(title: String, placeholder: String, valueState: Binding<ADRStatus?>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primaryGray)
            Menu {
                Picker(selection: $status, label: EmptyView()) {
                    Text("未選択").tag(ADRStatus?.none)
                    ForEach(ADRStatus.allCases, id: \.self) { status in
                        Text(status.title).tag(ADRStatus?.some(status))
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
            } label: {
                HStack {
                    if let status {
                        Text(status.title)
                    } else {
                        Text("提案/承認/却下/取下")
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 16))
                }
                .padding(6)
                .font(.system(size: 16))
                .foregroundStyle(
                    status == nil
                    ? .gray.opacity(0.5)
                    : .ultraDarkPrimary
                )
            }
            .background(.ultraLightPrimary)
            .frame(width: 200, height: 34)
            .cornerRadius(8)
        }
    }
    
    private func validate() -> Bool {
        var result = true
        var emptySections: [String] = []
        
        if status == nil {
            emptySections.append("ステータス")
            result = false
        }
        if decision.isEmpty {
            emptySections.append("決定内容")
            result = false
        }
        if context.isEmpty {
            emptySections.append("背景・理由")
            result = false
        }
        if !emptySections.isEmpty {
            validationMessage = emptySections.joined(separator: ", ") + "を入力してください"
        }
        return result
    }
    
    private func insertIntoContext() {
        let adr = ADR(
            status: status ?? .proposal,
            decision: decision,
            context: context,
            others: others
        )
        modelContext.insert(adr)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
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
          .background(Color(.appPrimary))
          .cornerRadius(.infinity)
          .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
          .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

#Preview {
    @Previewable @State var router = ADRListRouter()
    let adr = ADR(
        status: .approved,
        decision: "今日の晩御飯はカレーにする",
        context: "Instagramで流れてきたから",
        others: "食材の買い出しが必要"
    )
    ADRCreateScreenView()
}

