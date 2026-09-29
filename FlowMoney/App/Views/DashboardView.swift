//
//  DashboardView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/29.
//

import SwiftUI

struct DashboardView: View {
    let viewModel: TransactionViewModel

    var body: some View {
        List {
            Section("Category Spending") {
                ForEach(
                    viewModel.categorySpendingBreakdown.keys.sorted(),
                    id: \.self
                ) { category in
                    HStack {
                        Text(category)
                        Spacer()
                        Text(String(describing: viewModel.categorySpendingBreakdown[category] ?? 0))
                    }
                }
            }
        }
        .navigationTitle("Dashboard")
    }
}
