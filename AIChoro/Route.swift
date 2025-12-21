//
//  Route.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/20.
//

import SwiftUI

enum Route: Hashable {
    case adrList
    case adrDetail(adr: ADR)
    case choroAI
    
    var title: String {
        switch self {
        case .adrList: "ADR一覧"
        case .adrDetail: "ADR詳細"
        case .choroAI: "長老AI"
        }
    }
    
    @ViewBuilder
    func makeDestinationView() -> some View {
        switch self {
        case .adrList:
            ADRListScreenView()
        case .adrDetail(let adr):
            ADRDetailScreenView(adr: adr)
        case .choroAI:
            ChoroAIScreenView()
        }
    }
}
