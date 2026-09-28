//
//  VectorSearchService.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/17.
//

import SwiftData
import Foundation
import Accelerate

protocol VectorSearchServiceProtocol {
    func searchFull(queryText: String, topK: Int) async -> [SearchResult]
}

struct SearchResult: Identifiable, Equatable {
    let id = UUID()
    var score: Float
    var adr: ADR
}

struct TopKHeap<T> {
    private var items: [(score: Float, value: T)] = []
    private let k: Int
    
    init(k: Int) {
        self.k = k
    }
    
    mutating func push(score: Float, value: T) {
        if items.count < k {
            items.append((score, value))
            siftUp(from: items.count - 1)
        } else if let minScore = items.first?.score, score > minScore {
            items[0] = (score, value)
            siftDown(from: 0)
        }
    }
    
    func sortedDescending() -> [(Float, T)] {
        items.sorted { $0.score > $1.score }.map { ($0.score, $0.value) }
    }
    
    private mutating func siftUp(from index: Int) {
        var child = index
        while child > 0 {
            let parent = (child - 1) / 2
            if items[child].score < items[parent].score {
                items.swapAt(child, parent)
                child = parent
            } else {
                break
            }
        }
    }
    
    private mutating func siftDown(from index: Int) {
        var parent = index
        while true {
            let left = parent * 2 + 1
            let right = left + 1
            var smallest = parent
            
            if left < items.count, items[left].score < items[smallest].score {
                smallest = left
            }
            if right < items.count, items[right].score < items[smallest].score {
                smallest = right
            }
            
            if smallest == parent { break }
            items.swapAt(parent, smallest)
            parent = smallest
        }
    }
}

final class VectorSearchService: VectorSearchServiceProtocol {
    private let contextualEmbeddingSearvice: ContextualEmbeddingServiceProtocol
    private let modelContext: ModelContext
    
    init(
        contextualEmbeddingSearvice: ContextualEmbeddingServiceProtocol = ContextualEmbeddingService(),
        modelContext: ModelContext
    ) {
        self.contextualEmbeddingSearvice = contextualEmbeddingSearvice
        self.modelContext = modelContext
    }
    
    func searchFull(queryText: String, topK: Int = 5) async -> [SearchResult] {
        guard let queryEmbedding = await contextualEmbeddingSearvice.encode(text: queryText)
        else {
            fatalError("searchFull() vectorize failed: 埋め込みに失敗しました")
        }
        
        print("クエリテキスト: \(queryText)")
        
        do {
            // 全件取得
            let desc = FetchDescriptor<ADR>()
            let chunks = try modelContext.fetch(desc)
            
            var heap = TopKHeap<ADR>(k: topK)
            
            for chunk in chunks {
                // embeddingData -> [Float]
                guard let vector = chunk.embedding?.toFloatArray() else {
                    fatalError("searchFull() chunk embedding nil: \(String(describing: chunk.embedding))")
                }
                let score = vDSP.dot(queryEmbedding, vector)
                print("score: \(score), chunk: \(chunk.decision)")
                heap.push(score: score, value: chunk)
            }
            return heap.sortedDescending().map { (score, chunk) in
                return SearchResult(score: score, adr: chunk)
            }
        } catch {
            fatalError("searchFull() error: \(error)")
        }
    }
}

