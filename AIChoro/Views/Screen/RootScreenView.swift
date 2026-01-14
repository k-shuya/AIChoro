//
//  RootScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/18.
//

import SwiftUI

struct RootScreenView: View {
    @State private var rootRouter = RootRouter()
    
    var body: some View {
        TabView(selection: rootRouter.selectedTabBinding()) {
            Route.adrList.makeDestinationView()
                .tabItem {
                    Image(systemName: "folder")
                        .foregroundStyle(.primaryGray)
                        .font(.system(size: 24, weight: .semibold))
                        .environment(\.symbolVariants, .none)
                }
                .tag(RootRouter.Tab.adrList)
            Route.choroAI.makeDestinationView()
                .tabItem {
                    Image(systemName: "apple.intelligence")
                        .font(.system(size: 24, weight: .semibold))
                        .symbolRenderingMode(.palette)
                }
                .tag(RootRouter.Tab.choroAI)
        }
        .tint(Color(.primary))
        .environment(\.rootRouter, rootRouter)
    }
}

#Preview {
    RootScreenView()
}

