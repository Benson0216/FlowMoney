//
//  Transaction.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/25.
//

import Foundation
import SwiftData


enum PaymentMethod: String, Codable {
    case cash
    case creditCard
    case debitCard
    case applePay
    case bankTransfer
    case other
}

enum TransactionSource: String, Codable {
    case manual
    case quickAdd
    case csv
    case ocr
    case ai
    case bank
}

enum TransactionType: String, Codable {
    case income
    case expense
    case transfer
}

@Model
final class Transaction {
    var id: UUID
    
    var amount: Decimal
    var currencyCode: String
    var type: TransactionType
    
    var date: Date

    var merchantName: String
    var categoryName: String

    var paymentMethod: PaymentMethod
    var note: String?

    var source: TransactionSource

    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        amount: Decimal,
        currencyCode: String = "TWD",
        type: TransactionType = .expense,
        date: Date = .now,
        merchantName: String,
        categoryName: String,
        paymentMethod: PaymentMethod,
        note: String? = nil,
        source: TransactionSource = .manual,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.amount = amount
        self.currencyCode = currencyCode
        self.type = type
        self.date = date
        self.merchantName = merchantName
        self.categoryName = categoryName
        self.paymentMethod = paymentMethod
        self.note = note
        self.source = source
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
