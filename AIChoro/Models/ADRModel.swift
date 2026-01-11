//
//  ADRModel.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI
import SwiftData

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
final class ADR: Identifiable, Hashable {
    private(set) var id: UUID
    private(set) var createdAt = Date()
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
        self.status = status
        self.decision = decision
        self.context = context
        self.others = others
    }
}
