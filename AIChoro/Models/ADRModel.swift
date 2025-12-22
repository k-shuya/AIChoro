//
//  ADRModel.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI
import SwiftData

enum ADRStatus: Codable {
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
    private(set) var status: ADRStatus
    private(set) var decision: String
    private(set) var context: String
    private(set) var others: String
    private(set) var createdAt = Date()
    
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
