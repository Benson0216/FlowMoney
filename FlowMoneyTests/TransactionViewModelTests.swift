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
}
