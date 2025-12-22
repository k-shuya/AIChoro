//
//  AIChoroApp.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/18.
//

import SwiftUI
import SwiftData

@main
struct AIChoroApp: App {
    var body: some Scene {
        WindowGroup {
            RootScreenView()
        }
        .modelContainer(for: ADR.self)
    }
}
