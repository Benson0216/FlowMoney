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
            VStack(spacing: 0) {
                TextField(
                    "Search transactions",
                    text: Binding(
                        get: { viewModel.searchText },
                        set: { viewModel.searchText = $0 }
                    )
                )
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .padding(.vertical, 8)

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
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Filter", selection: Binding(
                            get: { viewModel.selectedFilter },
                            set: { viewModel.selectedFilter = $0 }
                        )) {
                            Text("All").tag(TransactionFilter.all)
                            Text("Income").tag(TransactionFilter.income)
                            Text("Expense").tag(TransactionFilter.expense)
                            Text("Transfer").tag(TransactionFilter.transfer)
                        }

                        Picker("Date", selection: Binding(
                            get: { viewModel.dateFilter },
                            set: { viewModel.dateFilter = $0 }
                        )) {
                            Text("All").tag(TransactionDateFilter.all)
                            Text("Today").tag(TransactionDateFilter.today)
                            Text("This Week").tag(TransactionDateFilter.thisWeek)
                            Text("This Month").tag(TransactionDateFilter.thisMonth)
                        }

                        Picker("Sort", selection: Binding(
                            get: { viewModel.sortOption },
                            set: { viewModel.sortOption = $0 }
                        )) {
                            Text("Newest").tag(TransactionSortOption.newestFirst)
                            Text("Oldest").tag(TransactionSortOption.oldestFirst)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }

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
    }
}
