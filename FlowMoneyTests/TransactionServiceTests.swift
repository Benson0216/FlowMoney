//
//  TransactionServiceTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/2.
//

import XCTest
import SwiftData
@testable import FlowMoney

final class TransactionServiceTests: XCTestCase {

    private func makeService() throws -> TransactionService {
        let container = try ModelContainer(
            for: Transaction.self,
            Category.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )

        let context = ModelContext(container)
        let repository = TransactionRepository(
            modelContext: context
        )

        return TransactionService(
            repository: repository
        )
    }

    func testCreateTransaction() throws {
        let service = try makeService()

        let transaction = try service.createTransaction(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        XCTAssertEqual(transaction.amount, 500)
        XCTAssertEqual(transaction.merchantName, "Lunch")
        XCTAssertEqual(transaction.categoryName, "Food")
        XCTAssertEqual(transaction.paymentMethod, .creditCard)
    }

    func testFetchTransactions() throws {
        let service = try makeService()

        _ = try service.createTransaction(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        _ = try service.createTransaction(
            amount: 1000,
            merchantName: "Taxi",
            categoryName: "Transport",
            paymentMethod: .cash
        )

        let transactions = try service.fetchTransactions()

        XCTAssertEqual(transactions.count, 2)
    }

    func testUpdateTransaction() throws {
        let service = try makeService()

        let transaction = try service.createTransaction(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        try service.updateTransaction(
            transaction,
            amount: 800,
            currencyCode: "TWD",
            type: .expense,
            date: transaction.date,
            merchantName: "Dinner",
            categoryName: "Food",
            category: nil,
            paymentMethod: .cash,
            note: "Updated",
            source: .manual
        )

        XCTAssertEqual(transaction.amount, 800)
        XCTAssertEqual(transaction.merchantName, "Dinner")
        XCTAssertEqual(transaction.paymentMethod, .cash)
        XCTAssertEqual(transaction.note, "Updated")
    }

    func testDeleteTransaction() throws {
        let service = try makeService()

        let transaction = try service.createTransaction(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        try service.deleteTransaction(transaction)

        let transactions = try service.fetchTransactions()

        XCTAssertEqual(transactions.count, 0)
    }

    func testCreateTransactionWithCategory() throws {
        let container = try ModelContainer(
            for: Transaction.self,
            Category.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )

        let context = ModelContext(container)

        let repository = TransactionRepository(
            modelContext: context
        )

        let service = TransactionService(
            repository: repository
        )

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        context.insert(category)
        try context.save()

        let transaction = try service.createTransaction(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            category: category,
            paymentMethod: .creditCard
        )

        XCTAssertNotNil(transaction.category)
        XCTAssertTrue(transaction.category === category)
    }
}
