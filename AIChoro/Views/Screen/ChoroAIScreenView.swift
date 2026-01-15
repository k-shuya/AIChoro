//
//  ChoroAIScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/19.
//

import SwiftUI

enum ScrollAnchor: Hashable {
    case top
    case bottom
}

struct MessageData: Identifiable, Equatable {
    var id: UUID = UUID()
    var text: String
    var timeStamp: Date
}

struct ChoroAIScreenView: View {
    enum ContentType {
        case userQuestion
        case agentAnswer
        case recommendedADR
        case debugInfo
    }
    
    struct Content: Identifiable, Equatable {
        var id: UUID = UUID()
        var type: ContentType
        var text: String
        
        static func == (lhs: Content, rhs: Content) -> Bool{
            return lhs.id == rhs.id
        }
    }
    
    @Environment(\.rootRouter) var rootRouter
    
    @State private var choroAIRouter = ChoroAIRouter()
    @State private var messageData: MessageData = MessageData(
        text: "", timeStamp: Date()
    )
    
    @State private var contentList: [Content] = []
    
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
        ScrollViewReader { proxy in
            VStack {
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(contentList) { content in
                            switch content.type {
                            case .userQuestion:
                                VStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        Text(content.text)
                                            .font(.system(size: 16))
                                            .foregroundStyle(Color(.ultraDarkPrimary))
                                            .lineLimit(nil)
                                            .frame(minHeight: 20)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 16)
                                    }
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                }
                                .padding(.horizontal, 24)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            case .agentAnswer:
                                Text(content.text)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 24)
                            case .recommendedADR:
                                EmptyView()
                            case .debugInfo:
                                EmptyView()
                            }
                        }
                        Color.clear.id(ScrollAnchor.bottom)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .scrollDismissesKeyboard(.immediately)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    ChatInputArea(messageData: $messageData)
                }
                .toolbar(.hidden, for: .tabBar)
            }
            .onChange(of: messageData) {
                contentList.append(
                    Content(
                        type: .userQuestion,
                        text: messageData.text
                    )
                )
            }
            .onChange(of: contentList) {
                withAnimation {
                    proxy.scrollTo(ScrollAnchor.bottom)
                }
            }
        }
    }
}

#Preview {
    ChoroAIScreenView()
}
