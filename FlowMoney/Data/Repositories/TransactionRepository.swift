//
//  TransactionRepository.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/1.
//

import Foundation
import SwiftData

final class TransactionRepository {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func create(
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
        let transaction = Transaction(
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

        modelContext.insert(transaction)
        try modelContext.save()

        return transaction
    }

    func fetchAll() throws -> [Transaction] {
        let descriptor = FetchDescriptor<Transaction>()
        return try modelContext.fetch(descriptor)
    }

    func update(
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
        transaction.amount = amount
        transaction.currencyCode = currencyCode
        transaction.type = type
        transaction.date = date
        transaction.merchantName = merchantName
        transaction.categoryName = categoryName
        transaction.category = category
        transaction.paymentMethod = paymentMethod
        transaction.note = note
        transaction.source = source
        transaction.updatedAt = .now

        try modelContext.save()
    }

    func delete(_ transaction: Transaction) throws {
        modelContext.delete(transaction)
        try modelContext.save()
    }
}
