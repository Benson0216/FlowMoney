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
            Section("Monthly Transaction Trend") {
                ForEach(
                    viewModel.monthlyTransactionTrend.keys.sorted(),
                    id: \.self
                ) { month in
                    let summary = viewModel.monthlyTransactionTrend[month]!

                    VStack(alignment: .leading, spacing: 4) {
                        Text(month, format: .dateTime.year().month())
                            .font(.headline)

                        HStack {
                            Text("Income")
                            Spacer()
                            Text(String(describing: summary.income))
                        }

                        HStack {
                            Text("Expense")
                            Spacer()
                            Text(String(describing: summary.expense))
                        }
                    }
                }
            }

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
