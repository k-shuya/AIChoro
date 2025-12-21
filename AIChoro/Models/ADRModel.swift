//
//  ADRModel.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI

enum ADRStatus: String, Hashable {
    case proposal = "提案"
    case approved = "承認"
    case rejected = "却下"
    case withdrew = "取下"
}

struct ADR: Identifiable, Hashable {
    let id = UUID()
    let status: ADRStatus
    let decision: String
    let context: String
    let others: String
    let createdAt = Date()
}

