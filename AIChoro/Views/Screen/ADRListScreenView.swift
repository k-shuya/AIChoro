//
//  ADRListScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/19.
//

import SwiftUI

struct ADRListScreenView: View {
    @State private var router = ADRListRouter()
    
    let adrList: [ADR] = [
        ADR(
            status: .approved,
            decision: "今日の晩御飯はカレーにする",
            context: "Instagramで流れてきたから",
            others: "食材の買い出しが必要"
        ),
        ADR(
            status: .withdrew,
            decision: "今日の晩御飯は寿司にする",
            context: "カレーの口になってしまったから",
            others: "来週寿司を食べる"
        ),
        ADR(
            status: .rejected,
            decision: "デスクトップPCを買う",
            context: "お金がなくて無理だと結論が出たため",
            others: "来年のボーナスが出たら再検討"
        )
    ]
    
    var body: some View {
        NavigationStack(path: router.pathBinding()) {
            ZStack {
                contentView
                //                error
                //                loading
            }
            .navigationDestination(
                for: Route.self,
                destination: { route in
                    route.makeDestinationView()
                }
            )
        }
    }
    
    var contentView: some View {
        VStack {
            adrListView
        }
    }
    
    var adrListView: some View {
        List(adrList) { adr in
            ADRListCell(adr: adr)
                .contentShape(Rectangle())
                .onTapGesture {
                    router.present(route: .adrDetail(adr: adr))
                }
        }
        .listStyle(.insetGrouped)
        .listRowSpacing(16)
    }
}

#Preview {
    ADRListScreenView()
}
