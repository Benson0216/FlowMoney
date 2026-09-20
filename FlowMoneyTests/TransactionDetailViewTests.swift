//
//  TransactionDetailViewTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/10.
//

import XCTest
@testable import FlowMoney

@MainActor
final class TransactionDetailViewTests: XCTestCase {

    func testTransactionDetailViewCanBeCreated() {
        let transaction = Transaction(
            amount: 150,
            currencyCode: "TWD",
            type: .expense,
            date: Date.now,
            merchantName: "Coffee Shop",
            categoryName: "Food",
            category: nil,
            paymentMethod: .creditCard,
            note: nil,
            source: .manual
        )

        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(
            service: mockService
        )

        let view = TransactionDetailView(
            transaction: transaction,
            viewModel: viewModel
        )

        XCTAssertNotNil(view)
    }

    func testTransactionDetailViewUpdatesTransaction() throws {
        let transaction = Transaction(
            amount: 150,
            currencyCode: "TWD",
            type: .expense,
            date: Date.now,
            merchantName: "Coffee Shop",
            categoryName: "Food",
            category: nil,
            paymentMethod: .creditCard,
            note: nil,
            source: .manual
        )

        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(
            service: mockService
        )

        viewModel.transactions = [transaction]

        try viewModel.updateTransaction(
            transaction,
            amount: 200,
            currencyCode: "TWD",
            type: .expense,
            date: transaction.date,
            merchantName: "Starbucks",
            categoryName: "Food",
            category: nil,
            paymentMethod: .creditCard,
            note: nil,
            source: .manual
        )

        XCTAssertEqual(transaction.amount, 200)
        XCTAssertEqual(transaction.merchantName, "Starbucks")
    }
}
