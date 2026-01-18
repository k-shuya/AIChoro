//
//  ChoroAIScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/19.
//

import SwiftUI
import SwiftData
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
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.rootRouter) var rootRouter
    
    @State private var vectorSearchService: VectorSearchServiceProtocol? = nil
    @State private var choroAIRouter = ChoroAIRouter()
    @State var isLoading : Bool = false
    @State private var messageData: MessageData = MessageData(
        text: "",
        timeStamp: Date()
    )
    
    @State private var contentList: [Content] = []
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack(path: choroAIRouter.pathBinding()) {
            ZStack {
                contentView
                    .onTapGesture { isFocused = false }
                    .onAppear {
                        if vectorSearchService == nil {
                            vectorSearchService = VectorSearchService(modelContext: modelContext)
                        }
                    }
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
                    
                    if isLoading {
                        agentLoadingView()
                    }
                    
                    Color.clear.id(ScrollAnchor.bottom)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.ultraLightPrimary))
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
                    guard let text = contentList.last?.text else { return }
//                    let result = await vectorSearchService.searchWithHNSW(text: text)
                    let result = await vectorSearchService?.searchFull(queryText: text, topK: 3)
                    await sendPrompt(searchResults: result ?? [])
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
    
    private func agentLoadingView() -> some View {
        VStack(spacing: 0) {
            BouncingDotsLoader()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func sendPrompt(searchResults: [(score: Float, adr: ADR)]) async {
        isLoading = true
        var adrTexts: [String] = []
        
        for result in searchResults {
            let adr = result.adr
            let adrText =
            """
            "決定内容": "\(adr.decision)",
            "ステータス": \(adr.status.title),
            "背景・理由": "\(adr.context)",
            "その他": "\(adr.others)"
            """
            adrTexts.append(adrText)
        }
        
        let adrPrompt = """
        "検索結果": [
        \(adrTexts.map { "    {\n        \($0)\n    }" }.joined(separator: ",\n"))
        ]
        """
        
        do {
            let session = LanguageModelSession()
            let prompt =
            """
            目的: 「ADR検索結果」を参照し、「ユーザーの入力」に対する回答を生成する
            制約: ハルシネーションしないでください。
            ユーザーの入力: \(messageData.text)
            ADR検索結果: \(adrPrompt)
            """
            for try await chunk in session.streamResponse(to: prompt) {
                await MainActor.run {
                    isLoading = false
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
