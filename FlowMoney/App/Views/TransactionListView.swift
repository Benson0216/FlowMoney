//
//  TransactionListView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/7.
//

import SwiftUI

struct TransactionListView: View {

    let viewModel: TransactionViewModel

    var body: some View {
        List {
            if viewModel.transactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions",
                    systemImage: "tray"
                )
            } else {
                ForEach(viewModel.transactions) { transaction in
                    VStack(alignment: .leading) {
                        Text(transaction.merchantName)
                        Text(transaction.categoryName)
                        Text(transaction.amount.description)
                            .foregroundStyle(
                                transaction.type == .income ? .green : .red
                            )
                        Text(
                            transaction.date.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
                    }
                }
            }
        }
        .task {
            try? viewModel.loadTransactions()
        }
    }
}


