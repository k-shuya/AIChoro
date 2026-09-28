//
//  DocumentEmbeddingService.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/17.
//

import Accelerate
import NaturalLanguage

protocol ContextualEmbeddingServiceProtocol {
    func encode(text: String) async -> [Float]?
}

final class ContextualEmbeddingService: ContextualEmbeddingServiceProtocol {
    let embeddingModel: NLContextualEmbedding
    
    init(language: NLLanguage = .japanese) {
        guard let model = NLContextualEmbedding(language: language) else {
            // TODO: エラーハンドリング
            fatalError("Failed to load model")
        }
        
        Task {
            if model.hasAvailableAssets {
                try model.load()
            } else {
                try await model.requestAssets()
                try model.load()
            }
        }
        
        self.embeddingModel = model
    }
    
    /// 文字列をコンテキストベクトル化（平均プーリング+L2正規化）
    func encode(text: String) async -> [Float]? {
        if !embeddingModel.hasAvailableAssets {
            Task {
                try await embeddingModel.requestAssets()
                try embeddingModel.load()
            }
        } else {
            do {
                let embeddingResult = try embeddingModel.embeddingResult(for: text, language: nil)
                
                var meanPooledEmbeddings = [Float](repeating: 0, count: embeddingModel.dimension)
                
                // トークンのベクトルを足し合わせる
                embeddingResult.enumerateTokenVectors(in: text.startIndex ..< text.endIndex) { (embedding, _) in
                    meanPooledEmbeddings = vDSP.add(meanPooledEmbeddings, vDSP.doubleToFloat(embedding))
                    return true
                }
                
                let sequenceLength = embeddingResult.sequenceLength
                if sequenceLength > 0 {
                    // 平均プーリング（トークンベクトルの総和をトークン数で平均して畳み込み）
                    let averaged = vDSP.divide(meanPooledEmbeddings, Float(sequenceLength))
                    return l2Normalize(averaged)
                }
                // L2 normalization
                return l2Normalize(meanPooledEmbeddings)
            } catch {
                print("error:", error)
            }
        }
        return nil
    }
    
    // L2 正規化（ベクトル全体を二乗和平方根で割って正規化）
    private func l2Normalize(_ x: [Float], epsilon: Float = 1e-12) -> [Float] {
        let norm = sqrt(vDSP.sumOfSquares(x)) + epsilon
        return vDSP.divide(x, norm)
    }
}
