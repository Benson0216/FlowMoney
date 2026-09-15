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

        let categoryService = MockCategoryService()
        let categoryViewModel = CategoryViewModel(service: categoryService)

        let view = AddTransactionView(
            viewModel: viewModel,
            categoryViewModel: categoryViewModel
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

    func testViewModelCanAddTransactionWithCategory() throws {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        try viewModel.addTransaction(
            amount: 200,
            currencyCode: "TWD",
            type: .expense,
            date: Date.now,
            merchantName: "Lunch",
            categoryName: "Food",
            category: category,
            paymentMethod: .creditCard,
            note: nil,
            source: .manual
        )

        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(
            viewModel.transactions.first?.category?.name,
            "Food"
        )
    }
}
