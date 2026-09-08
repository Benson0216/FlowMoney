//
//  AddTransactionViewTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/8.
//

import XCTest
@testable import FlowMoney

@MainActor
final class AddTransactionViewTests: XCTestCase {

    func testAddTransactionViewCanBeCreated() {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        let view = AddTransactionView(
            viewModel: viewModel
        )

        XCTAssertNotNil(view)
    }
    
    func testViewModelCanAddTransaction() throws {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.addTransaction(
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

        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(
            viewModel.transactions.first?.merchantName,
            "Coffee Shop"
        )
        XCTAssertEqual(
            viewModel.transactions.first?.amount,
            150
        )
    }
}
