//
//  ADRDetailScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI

struct ADRDetailScreenView: View {
    var adr: ADRModel
    
    var body: some View {
        ZStack {
            contentView
                .background(Color(.systemGroupedBackground))
//                error
//                loading
        }
    }
    
    var contentView: some View {
        VStack {
            Group {
                VStack(alignment: .leading, spacing: 24) {
                    sectionView(title: "決定内容", content: adr.decision)
                    sectionView(title: "ステータス", content: adr.status.rawValue)
                    sectionView(title: "背景・理由", content: adr.context)
                    sectionView(title: "その他", content: adr.others)
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
            
            Spacer()
        }
        .padding(16)
    }
    
    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primaryGray)
            Text(content)
                .font(.system(size: 16))
                .foregroundStyle(.ultraDarkPrimary)
        }
    }
}

#Preview {
    let adr = ADRModel(
        status: .approved,
        decision: "今日の晩御飯はカレーにする",
        context: "Instagramで流れてきたから",
        others: "食材の買い出しが必要"
    )
    ADRDetailScreenView(adr: adr)
}
