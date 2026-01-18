//
//  ADR.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI
import SwiftData
import Accelerate
import NaturalLanguage

enum ADRStatus: Codable, CaseIterable {
    case proposal
    case approved
    case rejected
    case withdrew
    
    var title: String {
        switch self {
        case .proposal: "提案"
        case .approved: "承認"
        case .rejected: "却下"
        case .withdrew: "取下"
        }
    }
}

@Model
final class VectorLabelCount {
    @Attribute(.unique)
    var current: Int

    init(current: Int = 0) {
        self.current = current
    }
}

@Model
final class ADR: Sendable, Identifiable, Hashable {
    private(set) var id: UUID
    private(set) var embedding: Data?
    private(set) var createdAt: Date
    
    var status: ADRStatus
    var decision: String
    var context: String
    var others: String
    
    init(
        status: ADRStatus,
        decision: String,
        context: String,
        others: String
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.status = status
        self.decision = decision
        self.context = context
        self.others = others
        
        Task {
            self.embedding = await vectorizeADR(
                decision: decision,
                status: status,
                context: context,
                others: others
            ).toData()
        }
    }
    
    private func vectorizeADR(
        decision: String,
        status: ADRStatus,
        context: String,
        others: String
    ) async -> [Float] {
        let adrText =
                """
                {
                    決定内容: "\(decision)",
                    ステータス: "\(await status.title)",
                    背景・理由: "\(context)",
                    その他: "\(others)",
                }
                """
        guard let encodedVector = await ContextualEmbeddingService().encode(text: adrText)
        else {
            fatalError("vectorizeADR(): 埋め込みに失敗しました")
        }
        
        return encodedVector
    }
}
