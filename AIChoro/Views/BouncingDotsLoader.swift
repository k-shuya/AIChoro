//
//  BouncingDotsLoader.swift
//  AIChoro
//
//  Created by 川村周也 on 2026/01/16.
//

import SwiftUI

struct BouncingDotsLoader: View {
    @State private var offsetY1: CGFloat = 0.0
    @State private var offsetY2: CGFloat = 0.0
    @State private var offsetY3: CGFloat = 0.0
    
    let dotSize: CGFloat = 8.0
    let bounceDistance: CGFloat = 8.0
    let animationDuration: Double = 0.5
    let delayBetweenDots: Double = 0.2

    var body: some View {
        HStack(spacing: 4) {
            DotView()
                .offset(y: offsetY1)
            DotView()
                .offset(y: offsetY2)
            DotView()
                .offset(y: offsetY3)
        }
        .onAppear {
            animateDots()
        }
    }

    private func animateDots() {
        withAnimation(
            Animation
                .easeInOut(duration: animationDuration)
                .repeatForever(autoreverses: true)
        ) {
            offsetY1 = bounceDistance
        }
        
        Task { @MainActor in
            try? await Task.sleep(
                nanoseconds: UInt64(delayBetweenDots * 1_000_000_000)
            )

            withAnimation(
                Animation
                    .easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true)
            ) {
                offsetY2 = bounceDistance
            }
        }

        Task { @MainActor in
            try? await Task.sleep(
                nanoseconds: UInt64(2 * delayBetweenDots * 1_000_000_000)
            )

            withAnimation(
                Animation
                    .easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true)
            ) {
                offsetY3 = bounceDistance
            }
        }
    }
}


struct DotView: View {
    let dotSize: CGFloat = 8.0
    
    var body: some View {
        Circle()
            .frame(width: dotSize, height: dotSize)
            .foregroundColor(Color(.primaryGray))
    }
}
