//
//  MockTransactionService.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/5.
//

import Foundation
@testable import FlowMoney

final class MockTransactionService: TransactionServiceProtocol {

    var transactions: [Transaction] = []
    
    var fetchError: Error?
    
    var createdTransaction: Transaction?
    var createError: Error?
    
    var updatedTransaction: Transaction?
    var updateError: Error?
    
    var deletedTransaction: Transaction?
    var deleteError: Error?

    func createTransaction(
        amount: Decimal,
        currencyCode: String,
        type: TransactionType,
        date: Date,
        merchantName: String,
        categoryName: String,
        category: FlowMoney.Category?,
        paymentMethod: PaymentMethod,
        note: String?,
        source: TransactionSource
    ) throws -> Transaction {
        if let createError {
            throw createError
        }

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

        createdTransaction = transaction
        transactions.append(transaction)

        return transaction
    }

    func fetchTransactions() throws -> [Transaction] {
        if let fetchError {
            throw fetchError
        }

        return transactions
    }

    func updateTransaction(
        _ transaction: Transaction,
        amount: Decimal,
        currencyCode: String,
        type: TransactionType,
        date: Date,
        merchantName: String,
        categoryName: String,
        category: FlowMoney.Category?,
        paymentMethod: PaymentMethod,
        note: String?,
        source: TransactionSource
    ) throws {
        if let updateError {
            throw updateError
        }

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

        updatedTransaction = transaction
    }

    func deleteTransaction(_ transaction: Transaction) throws {
        if let deleteError {
            throw deleteError
        }

        deletedTransaction = transaction
        transactions.removeAll { $0.id == transaction.id }
    }
}
