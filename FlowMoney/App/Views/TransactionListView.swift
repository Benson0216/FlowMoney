//
//  TransactionListView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/7.
//

import SwiftUI

struct TransactionListView: View {

    let viewModel: TransactionViewModel
    let categoryViewModel: CategoryViewModel

    var body: some View {
        NavigationStack {
            List {
                if viewModel.transactions.isEmpty {
                    ContentUnavailableView(
                        "No Transactions",
                        systemImage: "tray"
                    )
                } else {
                    ForEach(viewModel.sortedTransactions) { transaction in
                        NavigationLink {
                            TransactionDetailView(
                                transaction: transaction,
                                viewModel: viewModel
                            )
                        } label: {
                            VStack(alignment: .leading) {
                                Text(transaction.merchantName)
                                Text(transaction.categoryName)

                                Text(transaction.amount.description)
                                    .foregroundStyle(
                                        transaction.type == .income
                                            ? .green
                                            : .red
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
                    .onDelete { indexSet in
                        for index in indexSet {
                            let transaction = viewModel.transactions[index]

                            do {
                                try viewModel.deleteTransaction(transaction)
                            } catch {
                                // Error handling will be added later.
                            }
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CategoryListView(
                            viewModel: categoryViewModel
                        )
                    } label: {
                        Image(systemName: "folder")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddTransactionView(
                            viewModel: viewModel,
                            categoryViewModel: categoryViewModel
                        )
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                try? viewModel.loadTransactions()
            }
        }
        .searchable(
            text: Binding(
                get: { viewModel.searchText },
                set: { viewModel.searchText = $0 }
            ),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search transactions"
        )
    }
}
