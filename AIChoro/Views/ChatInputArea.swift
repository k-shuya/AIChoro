//
//  ChatInputArea.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/14.
//

import SwiftUI

struct ChatInputArea: View {
    @Environment(\.rootRouter) var rootRouter
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Button {
                    rootRouter.changeTab(tab: .adrList)
                } label: {
                    Image(systemName: "folder")
                        .font(.system(size: 24, weight: .semibold))
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .glassEffect(.clear.interactive())
                
                Spacer()
                
                FlexibleTextView()
            }
            .frame(height: 60, alignment: .bottom)
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }
}
