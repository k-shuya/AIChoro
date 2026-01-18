//
//  Data+Extensions.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/17.
//

import SwiftUI
import Foundation

extension Data {
    func toFloatArray() -> [Float] {
        precondition(self.count == 512 * MemoryLayout<Float>.size)
        return self.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
    }
}
