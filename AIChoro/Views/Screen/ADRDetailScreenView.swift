//
//  ADRDetailScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI

struct ADRDetailScreenView: View {
    var adr: ADR
    
    var body: some View {
        ZStack {
            contentView
//                error
//                loading
        }
    }
    
    var contentView: some View {
        VStack {
            detailContentView
        }
    }
    
    var detailContentView: some View {
        ZStack {
            Text(adr.decision)
        }
    }
}

