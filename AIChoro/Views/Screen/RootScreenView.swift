//
//  RootScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/18.
//

import SwiftUI

struct RootScreenView: View {
    var body: some View {
        TabView {
            ADRListScreenView()
                .tabItem {
                    Label("ADR一覧", systemImage: "folder")
                }
            ChoroAIScreenView()
                .tabItem {
                    Label("長老AI", systemImage: "apple.intelligence")
                }
        }
        .tint(Color("Primary"))
    }
}

#Preview {
    RootScreenView()
}

