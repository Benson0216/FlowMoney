//
//  TransactionServiceProtocol.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/5.
//

import Foundation

protocol TransactionServiceProtocol {

    func createTransaction(
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
    ) throws -> Transaction

    func fetchTransactions() throws -> [Transaction]

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
    ) throws

    func deleteTransaction(
        _ transaction: Transaction
    ) throws
}
