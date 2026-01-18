//
//  ADRListScreenView.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/19.
//

import SwiftUI
import SwiftData

struct ADRListScreenView: View {
    @Environment(\.rootRouter) var rootRouter
    @Environment(\.modelContext) var modelContext
    
    @Query private var adrs: [ADR]

    @State private var adrListRouter = ADRListRouter()
    
    var body: some View {
        NavigationStack(path: adrListRouter.pathBinding()) {
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
        .environment(\.adrListRouter, adrListRouter)
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
                    .contentShape(RoundedRectangle(cornerRadius: 24))
                    .onTapGesture {
                        adrListRouter.present(route: .adrDetail(adr: adr))
                    }
                    .listRowBackground(
                        // スワイプ削除で角丸が解除されるバグの対策
                        Color(.secondarySystemGroupedBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    )
            }
            .onDelete(perform: removeContext)
        }
        .scrollContentBackground(.hidden)
        .background(Color(.ultraLightPrimary))
        .listRowSpacing(16)
        .overlay(
            Group {
                if adrs.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "text.page.slash")
                            .font(.system(size: 60))
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.primaryGray.opacity(0.5))
                        Text("No ADR")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.primaryGray)
                        Text("意思決定を記録しましょう")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.primaryGray.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                }
            }
        )
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            Button {
                adrListRouter.present(route: .adrCreate)
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(width: 52, height: 52)
        }
    }
    
    private func removeContext(_ offsets: IndexSet) {
        for offset in offsets {
            let adr = adrs[offset]
            modelContext.delete(adr)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ADRListScreenView().contentView
}
