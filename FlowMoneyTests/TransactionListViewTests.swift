//
//  TransactionListViewTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/7.
//

import XCTest
@testable import FlowMoney

@MainActor
final class TransactionListViewTests: XCTestCase {

    @MainActor
    func testTransactionListViewCanBeCreated() {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        let view = TransactionListView(viewModel: viewModel)

        XCTAssertNotNil(view)
    }
    
    @MainActor
    func testViewModelLoadsTransactions() throws {
        let mockService = MockTransactionService()

        let transaction = Transaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Coffee Shop",
            categoryName: "Food",
            category: nil,
            paymentMethod: .creditCard,
            note: nil,
            source: .manual
        )

        mockService.transactions = [transaction]

        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.loadTransactions()

        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(
            viewModel.transactions.first?.merchantName,
            "Coffee Shop"
        )
    }
}
