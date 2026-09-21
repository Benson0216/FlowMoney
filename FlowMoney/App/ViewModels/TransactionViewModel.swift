//
//  TransactionViewModel.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/5.
//

import Foundation
import Observation

enum TransactionFilter {
    case all
    case income
    case expense
    case transfer
}

@MainActor
@Observable
final class TransactionViewModel {

    var transactions: [Transaction] = []
    var selectedFilter: TransactionFilter = .all
    
    var filteredTransactions: [Transaction] {
        switch selectedFilter {
        case .all:
            transactions
        case .income:
            transactions.filter { $0.type == .income }
        case .expense:
            transactions.filter { $0.type == .expense }
        case .transfer:
            transactions.filter { $0.type == .transfer }
        }
    }
    
    private let service: TransactionServiceProtocol

    init(service: TransactionServiceProtocol) {
        self.service = service
    }
    
    func loadTransactions() throws {
        transactions = try service.fetchTransactions()
    }
    
    func addTransaction(
        amount: Decimal,
        currencyCode: String,
        type: TransactionType,
        date: Date,
        merchantName: String,
        categoryName: String,
        category: Category?,
        paymentMethod: PaymentMethod,
        note: String?,
        source: TransactionSource
    ) throws {
        let transaction = try service.createTransaction(
            amount: amount,
            currencyCode: currencyCode,
            type: type,
            date: date,
            merchantName: merchantName,
            categoryName: categoryName,
            category: category,
            paymentMethod: paymentMethod,
            note: note,
            source: source
        )

        transactions.append(transaction)
    }
    
    func updateTransaction(
        _ transaction: Transaction,
        amount: Decimal,
        currencyCode: String,
        type: TransactionType,
        date: Date,
        merchantName: String,
        categoryName: String,
        category: Category?,
        paymentMethod: PaymentMethod,
        note: String?,
        source: TransactionSource
    ) throws {
        try service.updateTransaction(
            transaction,
            amount: amount,
            currencyCode: currencyCode,
            type: type,
            date: date,
            merchantName: merchantName,
            categoryName: categoryName,
            category: category,
            paymentMethod: paymentMethod,
            note: note,
            source: source
        )
    }
    
    func deleteTransaction(_ transaction: Transaction) throws {
        try service.deleteTransaction(transaction)

        transactions.removeAll { $0.id == transaction.id }
    }
}
