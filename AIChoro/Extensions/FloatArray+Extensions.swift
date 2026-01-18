//
//  FloatArray+Extensions.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/17.
//

import SwiftUI
import Foundation

extension Array where Element == Float {
    func toData() -> Data {
        return self.withUnsafeBufferPointer { Data(buffer: $0) }
    }
}
