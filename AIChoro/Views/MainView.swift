//
//  MainView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/18.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ADRListView()
                .tabItem {
                    Label("ADR一覧", systemImage: "folder")
                }
                .tag(1)
            ChoroAIView()
                .tabItem {
                    Label("長老AI", systemImage: "apple.intelligence")
                }
        }
        .tint(Color("Primary"))
        
    }
}

#Preview {
    MainView()
}
