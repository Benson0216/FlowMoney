//
//  TransactionRepositoryTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/1.
//

import XCTest
import SwiftData
@testable import FlowMoney

final class TransactionRepositoryTests: XCTestCase {

    private func makeRepository() throws -> TransactionRepository {
        let container = try ModelContainer(
            for: Transaction.self,
            Category.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let context = ModelContext(container)

        return TransactionRepository(modelContext: context)
    }

    func testCreateTransaction() throws {
        let repository = try makeRepository()

        let transaction = try repository.create(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        XCTAssertEqual(transaction.amount, 500)
        XCTAssertEqual(transaction.currencyCode, "TWD")
        XCTAssertEqual(transaction.type, .expense)
        XCTAssertEqual(transaction.merchantName, "Lunch")
        XCTAssertEqual(transaction.categoryName, "Food")
        XCTAssertEqual(transaction.paymentMethod, .creditCard)
        XCTAssertEqual(transaction.source, .manual)
        XCTAssertNil(transaction.note)
    }

    func testFetchAllTransactions() throws {
        let repository = try makeRepository()

        _ = try repository.create(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        _ = try repository.create(
            amount: 1000,
            merchantName: "Taxi",
            categoryName: "Transport",
            paymentMethod: .cash
        )

        let transactions = try repository.fetchAll()

        XCTAssertEqual(transactions.count, 2)
    }

    func testUpdateTransaction() throws {
        let repository = try makeRepository()

        let transaction = try repository.create(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        let originalUpdatedAt = transaction.updatedAt

        try repository.update(
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

        XCTAssertGreaterThanOrEqual(
            transaction.updatedAt,
            originalUpdatedAt
        )
    }

    func testDeleteTransaction() throws {
        let repository = try makeRepository()

        let transaction = try repository.create(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        try repository.delete(transaction)

        let transactions = try repository.fetchAll()

        XCTAssertEqual(transactions.count, 0)
    }

    func testCreateTransactionWithCategory() throws {
        let container = try ModelContainer(
            for: Transaction.self,
            Category.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let context = ModelContext(container)
        let repository = TransactionRepository(modelContext: context)

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        context.insert(category)
        try context.save()

        let transaction = try repository.create(
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
