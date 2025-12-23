//
//  ADRListScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/19.
//

import SwiftUI
import SwiftData

struct ADRListScreenView: View {
    @Environment(\.modelContext) var context
    @Query private var adrs: [ADR]
    
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
            .navigationTitle(Route.adrList.title)
            .navigationBarTitleDisplayMode(.inline)
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
                .toolbar { toolbar }
        }
    }
    
    var adrListView: some View {
        List {
            ForEach(adrs) { adr in
                ADRListCell(adr: adr)
//                    .contentShape(Rectangle())
                    .onTapGesture {
                        router.present(route: .adrDetail(adr: adr))
                    }
            }
            .onDelete(perform: removeContext)
        }
        .listStyle(.insetGrouped)
        .listRowSpacing(16)
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            Button {
                router.present(route: .adrInput(adr: nil))
//                insertIntoContext()
                print("追加ボタンがタップされました")
            } label: {
                Image(systemName: "plus")
            }
            .frame(width: 52, height: 52)
        }
    }
    
    private func insertIntoContext() {
        let adr = ADR(
            status: .proposal,
            decision: "",
            context: "",
            others: ""
        )
        context.insert(adr)
        saveContext()
    }
    
    private func removeContext(_ offsets: IndexSet) {
        for offset in offsets {
            let adr = adrs[offset]
            context.delete(adr)
            saveContext()
        }
        
//        if let data = adrs.first(where: { $0.id == adrs.last.id }) {
//            context.delete(data)
//            saveContext()
//        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ADRListScreenView().contentView
}
