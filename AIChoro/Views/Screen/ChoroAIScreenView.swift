//
//  ChoroAIScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/19.
//

import SwiftUI

struct ChoroAIScreenView: View {
    @Environment(\.rootRouter) var rootRouter
    
    @State private var choroAIRouter = ChoroAIRouter()
    @State private var searchText = ""
    @State private var isSearching = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack(path: choroAIRouter.pathBinding()) {
            ZStack {
                contentView
                    .onTapGesture { isFocused = false }
            }
            .navigationTitle(Route.choroAI.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(
                for: Route.self,
                destination: { route in
                    route.makeDestinationView()
                }
            )
        }
        .environment(\.choroAIRouter, choroAIRouter)
    }
    
    var contentView: some View {
        VStack {
            ScrollView {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Choro View")
                }
                .toolbar(.hidden, for: .tabBar)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .scrollDismissesKeyboard(.immediately)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ChatInputArea()
            }
        }
    }
}

#Preview {
    ChoroAIScreenView()
}
