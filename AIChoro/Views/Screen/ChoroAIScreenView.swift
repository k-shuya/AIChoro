//
//  ChoroAIScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/19.
//

import SwiftUI
import FoundationModels

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
        case userMessage
        case agentAnswer
        case recommendedADR
        case debugInfo
    }
    
    struct Content: Identifiable, Equatable {
        var id: UUID = UUID()
        var type: ContentType
        var text: String
        
        static func == (lhs: Content, rhs: Content) -> Bool {
            lhs.id == rhs.id
            && lhs.type == rhs.type
            && lhs.text == rhs.text
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
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(contentList) { content in
                        switch content.type {
                        case .userMessage:
                            userMessageView(text: content.text)
                        case .agentAnswer:
                            agentAnswerView(text: content.text)
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
            .onChange(of: messageData) {
                contentList.append(
                    Content(
                        type: .userMessage,
                        text: messageData.text
                    )
                )
                Task {
                    await sendPrompt()
                }
            }
            .onChange(of: contentList) {
                withAnimation {
                    if contentList.last?.type == .userMessage {
                        proxy.scrollTo(ScrollAnchor.bottom)
                    }
                }
            }
        }
    }
    
    private func userMessageView(text: String) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text(text)
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
    }
    
    private func agentAnswerView(text: String) -> some View {
        Text(text)
            .font(.system(size: 16))
            .foregroundStyle(Color(.ultraDarkPrimary))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
    }
    
    private func sendPrompt() async {
        do {
            let session = LanguageModelSession()
            let prompt =
            """
            目的：情報の検索
            方針：まず、入力されたメッセージを元に、ユーザーがどのような情報を求めているか分析し、関連しそうなキーワードを3つ挙げます。次に、それぞれのキーワードについて情報を検索します。最後に、情報をまとめてユーザーに返答してください。
            制約：思考の過程は回答に含めず、最後のまとめのみ回答すること。ハルシネーションしないでください。
            プロンプト：\(messageData.text)
            """
            for try await chunk in session.streamResponse(to: prompt) {
                await MainActor.run {
                    guard let index = contentList.indices.last else { return }
                    switch contentList[index].type {
                    case .userMessage:
                        contentList.append(
                            Content(
                                type: .agentAnswer,
                                text: chunk.content
                            )
                        )
                    case .agentAnswer:
                        contentList[index].text = chunk.content
                    case .debugInfo, .recommendedADR:
                        break
                    }
                }
            }
        } catch {
            contentList.append(
                Content(
                    type: .agentAnswer,
                    text: "ローカルLLMへの接続に失敗しました: \(error.localizedDescription)"
                )
            )
        }
    }
}

#Preview {
    ChoroAIScreenView()
}
