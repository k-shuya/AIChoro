//
//  ADRListCell.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI

struct ADRListCell: View {
    let adr: ADR
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "swift")
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 4) {
                Text(adr.decision)
                    .font(.system(size: 16, weight: .semibold))
                Text(adr.createdAt,
                     format: Date.FormatStyle(date: .numeric, time: .omitted)
                )
                .font(.system(size: 14)).foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all, 0)
        }
        .frame(maxWidth: .infinity)
    }
}
