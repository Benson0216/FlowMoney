//
//  TransactionViewModelTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/5.
//

import XCTest
@testable import FlowMoney

enum TransactionViewModelTestError: Error {
    case fetchFailed
}

@MainActor
final class TransactionViewModelTests: XCTestCase {
    
    func testInitialTransactionsIsEmpty() {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        XCTAssertTrue(viewModel.transactions.isEmpty)
    }
    
    func testLoadTransactions() throws {
        let mockService = MockTransactionService()

        let transaction = Transaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Test Merchant",
            categoryName: "Food",
            paymentMethod: .cash,
            source: .manual
        )

        mockService.transactions = [transaction]

        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.loadTransactions()

        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(viewModel.transactions.first?.merchantName, "Test Merchant")
    }
    
    func testLoadTransactionsThrowsError() {
        let mockService = MockTransactionService()
        mockService.fetchError = TransactionViewModelTestError.fetchFailed

        let viewModel = TransactionViewModel(service: mockService)

        XCTAssertThrowsError(try viewModel.loadTransactions()) { error in
            XCTAssertTrue(error is TransactionViewModelTestError)
        }
    }
    
    func testAddTransaction() throws {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.addTransaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Test Merchant",
            categoryName: "Food",
            category: nil,
            paymentMethod: .cash,
            note: nil,
            source: .manual
        )

        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(
            viewModel.transactions.first?.merchantName,
            "Test Merchant"
        )
        XCTAssertEqual(
            viewModel.transactions.first?.amount,
            100
        )
    }
    
    func testAddTransactionThrowsError() {
        let mockService = MockTransactionService()
        mockService.createError = TransactionViewModelTestError.fetchFailed

        let viewModel = TransactionViewModel(service: mockService)

        XCTAssertThrowsError(
            try viewModel.addTransaction(
                amount: 100,
                currencyCode: "TWD",
                type: .expense,
                date: .now,
                merchantName: "Test Merchant",
                categoryName: "Food",
                category: nil,
                paymentMethod: .cash,
                note: nil,
                source: .manual
            )
        ) { error in
            XCTAssertTrue(error is TransactionViewModelTestError)
        }

        XCTAssertTrue(viewModel.transactions.isEmpty)
    }
    
    func testUpdateTransaction() throws {
        let mockService = MockTransactionService()

        let transaction = Transaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Old Merchant",
            categoryName: "Food",
            paymentMethod: .cash,
            source: .manual
        )

        mockService.transactions = [transaction]

        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.loadTransactions()

        try viewModel.updateTransaction(
            transaction,
            amount: 200,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "New Merchant",
            categoryName: "Shopping",
            category: nil,
            paymentMethod: .creditCard,
            note: "Updated",
            source: .manual
        )

        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(viewModel.transactions.first?.amount, 200)
        XCTAssertEqual(
            viewModel.transactions.first?.merchantName,
            "New Merchant"
        )
        XCTAssertEqual(
            viewModel.transactions.first?.categoryName,
            "Shopping"
        )
    }
    
    func testUpdateTransactionThrowsError() throws {
        let mockService = MockTransactionService()
        mockService.updateError = TransactionViewModelTestError.fetchFailed

        let transaction = Transaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Test Merchant",
            categoryName: "Food",
            paymentMethod: .cash,
            source: .manual
        )

        mockService.transactions = [transaction]

        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.loadTransactions()

        XCTAssertThrowsError(
            try viewModel.updateTransaction(
                transaction,
                amount: 200,
                currencyCode: "TWD",
                type: .expense,
                date: .now,
                merchantName: "Updated Merchant",
                categoryName: "Shopping",
                category: nil,
                paymentMethod: .creditCard,
                note: nil,
                source: .manual
            )
        ) { error in
            XCTAssertTrue(error is TransactionViewModelTestError)
        }

        XCTAssertEqual(
            viewModel.transactions.first?.merchantName,
            "Test Merchant"
        )
    }
    
    func testDeleteTransaction() throws {
        let mockService = MockTransactionService()

        let transaction = Transaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Test Merchant",
            categoryName: "Food",
            paymentMethod: .cash,
            source: .manual
        )

        mockService.transactions = [transaction]

        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.loadTransactions()

        try viewModel.deleteTransaction(transaction)

        XCTAssertTrue(viewModel.transactions.isEmpty)
        XCTAssertEqual(
            mockService.deletedTransaction?.id,
            transaction.id
        )
    }
    
    func testDeleteTransactionThrowsError() throws {
        let mockService = MockTransactionService()
        mockService.deleteError = TransactionViewModelTestError.fetchFailed

        let transaction = Transaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Test Merchant",
            categoryName: "Food",
            paymentMethod: .cash,
            source: .manual
        )

        mockService.transactions = [transaction]

        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.loadTransactions()

        XCTAssertThrowsError(
            try viewModel.deleteTransaction(transaction)
        ) { error in
            XCTAssertTrue(error is TransactionViewModelTestError)
        }

        // 刪除失敗時，ViewModel 不應該移除交易
        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(
            viewModel.transactions.first?.merchantName,
            "Test Merchant"
        )
    }
    
    func testUpdateTransactionUpdatesTransaction() throws {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

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

    func testDeleteTransactionRemovesTransaction() throws {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        try viewModel.addTransaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: .now,
            merchantName: "Test Store",
            categoryName: "",
            category: nil,
            paymentMethod: .cash,
            note: nil,
            source: .manual
        )

        let transaction = try XCTUnwrap(viewModel.transactions.first)

        try viewModel.deleteTransaction(transaction)

        XCTAssertTrue(viewModel.transactions.isEmpty)
    }
    
    func testFilterTransactionsByType() throws {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        let income = Transaction(
            amount: 1000,
            currencyCode: "TWD",
            type: .income,
            date: .now,
            merchantName: "Salary",
            categoryName: "Income",
            category: nil,
            paymentMethod: .bankTransfer,
            note: nil,
            source: .manual
        )

        let expense = Transaction(
            amount: 200,
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

        let transfer = Transaction(
            amount: 500,
            currencyCode: "TWD",
            type: .transfer,
            date: .now,
            merchantName: "Bank Transfer",
            categoryName: "Transfer",
            category: nil,
            paymentMethod: .bankTransfer,
            note: nil,
            source: .manual
        )

        viewModel.transactions = [income, expense, transfer]

        viewModel.selectedFilter = .expense

        XCTAssertEqual(viewModel.filteredTransactions.count, 1)
        XCTAssertEqual(
            viewModel.filteredTransactions.first?.merchantName,
            "Coffee Shop"
        )
    }

    func testSortTransactionsByDate() throws {
        let mockService = MockTransactionService()
        let viewModel = TransactionViewModel(service: mockService)

        let olderTransaction = Transaction(
            amount: 100,
            currencyCode: "TWD",
            type: .expense,
            date: Date(timeIntervalSince1970: 1_000),
            merchantName: "Older",
            categoryName: "Food",
            category: nil,
            paymentMethod: .cash,
            note: nil,
            source: .manual
        )

        let newerTransaction = Transaction(
            amount: 200,
            currencyCode: "TWD",
            type: .expense,
            date: Date(timeIntervalSince1970: 2_000),
            merchantName: "Newer",
            categoryName: "Food",
            category: nil,
            paymentMethod: .cash,
            note: nil,
            source: .manual
        )

        viewModel.transactions = [
            olderTransaction,
            newerTransaction
        ]

        viewModel.sortOption = .newestFirst

        XCTAssertEqual(
            viewModel.sortedTransactions.first?.merchantName,
            "Newer"
        )

        viewModel.sortOption = .oldestFirst

        XCTAssertEqual(
            viewModel.sortedTransactions.first?.merchantName,
            "Older"
        )
    }
}
