//
//  DashboardViewTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/29.
//

import XCTest
@testable import FlowMoney

@MainActor
final class DashboardViewTests: XCTestCase {

    func testDashboardViewCanBeCreated() {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        let view = DashboardView(viewModel: viewModel)

        XCTAssertNotNil(view)
    }

    func testDashboardViewDisplaysCategorySpending() throws {
        let mockService = MockTransactionService()

        let transaction = Transaction(
            amount: 800,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Restaurant",
            categoryName: "Food",
            category: nil,
            paymentMethod: .cash,
            note: nil,
            source: .manual
        )

        mockService.transactions = [transaction]

        let viewModel = TransactionViewModel(service: mockService)
        try viewModel.loadTransactions()

        let view = DashboardView(viewModel: viewModel)

        XCTAssertEqual(
            viewModel.categorySpendingBreakdown["Food"],
            800
        )

        XCTAssertNotNil(view)
    }

    func testDashboardViewDisplaysMonthlyTransactionTrend() throws {
        let mockService = MockTransactionService()

        let transaction = Transaction(
            amount: 1500,
            currencyCode: "TWD",
            type: .expense,
            date: Calendar.current.date(
                from: DateComponents(year: 2026, month: 9, day: 15)
            )!,
            merchantName: "Restaurant",
            categoryName: "Food",
            category: nil,
            paymentMethod: .cash,
            note: nil,
            source: .manual
        )

        mockService.transactions = [transaction]

        let viewModel = TransactionViewModel(service: mockService)
        try viewModel.loadTransactions()

        let view = DashboardView(viewModel: viewModel)

        let month = Calendar.current.date(
            from: DateComponents(year: 2026, month: 9)
        )!

        XCTAssertEqual(
            viewModel.monthlyTransactionTrend[month]?.expense,
            1500
        )

        XCTAssertEqual(
            viewModel.monthlyTransactionTrend[month]?.income,
            0
        )

        XCTAssertNotNil(view)
    }
}
