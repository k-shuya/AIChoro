//
//  RootRouter.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/11.
//

import SwiftUI

@Observable
final class RootRouter {
    enum Tab: Hashable {
        case adrList
        case choroAI
    }
    
    private(set) var selectedTab: Tab = .adrList
    
    func selectedTabBinding() -> Binding<Tab> {
        Binding(
            get: { self.selectedTab },
            set: { self.selectedTab = $0 }
        )
    }

    func changeTab(tab: Tab) {
        selectedTab = tab
    }
}

extension EnvironmentValues {
    @Entry var rootRouter: RootRouter = RootRouter()
}
