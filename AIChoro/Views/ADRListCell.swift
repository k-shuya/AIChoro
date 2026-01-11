//
//  ADRListCell.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI

struct ADRListCell: View {
    let adr: ADR
    var statusImageTitle: String {
        switch adr.status {
        case .proposal:
            return "lightbulb"
        case .approved:
            return "checkmark"
        case .rejected:
            return "xmark"
        case .withdrew:
            return "slash.circle"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Image(systemName: "viewfinder")
                    .font(.system(size: 32, weight: .semibold))
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color(.primary))
                Image(systemName: statusImageTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color(.primary))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(adr.decision)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.ultraDarkPrimary)
                Text(adr.createdAt,
                     format: Date.FormatStyle(date: .numeric, time: .omitted)
                )
                .font(.system(size: 14))
                .foregroundStyle(.primaryGray)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.all, 0)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let adr = ADR(
        status: .approved,
        decision: "今日の晩御飯はカレーにする",
        context: "Instagramで流れてきたから",
        others: "食材の買い出しが必要"
    )
    List{
        ADRListCell(adr: adr)
    }
}
