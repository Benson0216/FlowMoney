//
//  TransactionService.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/2.
//

import Foundation

final class TransactionService {

    private let repository: TransactionRepository

    init(repository: TransactionRepository) {
        self.repository = repository
    }

    func createTransaction(
        amount: Decimal,
        currencyCode: String = "TWD",
        type: TransactionType = .expense,
        date: Date = .now,
        merchantName: String,
        categoryName: String,
        category: Category? = nil,
        paymentMethod: PaymentMethod,
        note: String? = nil,
        source: TransactionSource = .manual
    ) throws -> Transaction {
        try repository.create(
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

    func fetchTransactions() throws -> [Transaction] {
        try repository.fetchAll()
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
        try repository.update(
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
        try repository.delete(transaction)
    }
}
