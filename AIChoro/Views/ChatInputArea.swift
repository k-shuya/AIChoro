//
//  ChatInputArea.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/14.
//

import SwiftUI

struct ChatInputArea: View {
    @Environment(\.rootRouter) var rootRouter
    
    @Binding var messageData: MessageData
    
    var body: some View {
        HStack(alignment: .bottom) {
            Button {
                rootRouter.changeTab(tab: .adrList)
            } label: {
                Image(systemName: "folder")
                    .font(.system(size: 24, weight: .semibold))
            }
            .frame(width: 60, height: 60)
            .glassEffect(.regular.interactive())
            
            Spacer()
            
            FlexibleTextView(messageData: $messageData)
        }
        .padding(.horizontal, 16)
    }
}
