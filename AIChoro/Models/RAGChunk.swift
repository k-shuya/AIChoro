//
//  RAGChunk.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/17.
//

import SwiftData
import Foundation
import NaturalLanguage

@Model
final class RAGChunk {
    @Attribute(.unique)
    private(set) var id: UUID
    var text: String
    var embedding: Data
    private(set) var createdAt: Date
    
    init(
        id: UUID = UUID(),
        text: String,
        embedding: Data,
        createdAt: Date
    ) {
        self.id = id
        self.text = text
        self.embedding = embedding
        self.createdAt = Date()
    }
}
