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
            Route.adrList.makeDestinationView()
                .tabItem {
                    Label("ADR一覧", systemImage: "folder")
                }
            Route.choroAI.makeDestinationView()
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

