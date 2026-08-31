//
//  TransactionTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/26.
//

import XCTest
import SwiftData
@testable import FlowMoney

final class TransactionTests: XCTestCase {

    func testCreateExpenseTransaction() {
        let transaction = Transaction(
            amount: 250,
            merchantName: "Starbucks",
            categoryName: "Food",
            paymentMethod: .applePay
        )

        XCTAssertEqual(transaction.amount, 250)
        XCTAssertEqual(transaction.currencyCode, "TWD")
        XCTAssertEqual(transaction.type, .expense)
        XCTAssertEqual(transaction.merchantName, "Starbucks")
        XCTAssertEqual(transaction.categoryName, "Food")
        XCTAssertEqual(transaction.paymentMethod, .applePay)
        XCTAssertEqual(transaction.source, .manual)
        XCTAssertNil(transaction.note)
    }
    
    func testCreateCustomTransaction() {
        let date = Date(timeIntervalSince1970: 1_000_000)

        let transaction = Transaction(
            amount: 1234.50,
            currencyCode: "USD",
            type: .income,
            date: date,
            merchantName: "ACME",
            categoryName: "Salary",
            paymentMethod: .bankTransfer,
            note: "August salary",
            source: .manual
        )

        XCTAssertEqual(transaction.amount, 1234.50)
        XCTAssertEqual(transaction.currencyCode, "USD")
        XCTAssertEqual(transaction.type, .income)
        XCTAssertEqual(transaction.date, date)
        XCTAssertEqual(transaction.merchantName, "ACME")
        XCTAssertEqual(transaction.categoryName, "Salary")
        XCTAssertEqual(transaction.paymentMethod, .bankTransfer)
        XCTAssertEqual(transaction.note, "August salary")
        XCTAssertEqual(transaction.source, .manual)
    }
    
    func testTransactionTypes() {
        let income = Transaction(
            amount: 50000,
            type: .income,
            merchantName: "Company",
            categoryName: "Salary",
            paymentMethod: .bankTransfer
        )

        let expense = Transaction(
            amount: 500,
            type: .expense,
            merchantName: "Restaurant",
            categoryName: "Food",
            paymentMethod: .creditCard
        )

        let transfer = Transaction(
            amount: 10000,
            type: .transfer,
            merchantName: "My Bank",
            categoryName: "Transfer",
            paymentMethod: .bankTransfer
        )

        XCTAssertEqual(income.type, .income)
        XCTAssertEqual(expense.type, .expense)
        XCTAssertEqual(transfer.type, .transfer)
    }
    
    func testTransactionCanHaveCategory() {
        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        let transaction = Transaction(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            category: category,
            paymentMethod: .creditCard
        )

        XCTAssertNotNil(transaction.category)
        XCTAssertTrue(transaction.category === category)
    }
    
    func testTransactionCanExistWithoutCategory() {
        let transaction = Transaction(
            amount: 500,
            merchantName: "Unknown",
            categoryName: "Uncategorized",
            paymentMethod: .cash
        )

        XCTAssertNil(transaction.category)
    }
    
    func testTransactionCategoryRelationshipPersists() throws {
        let container = try ModelContainer(
            for: Transaction.self,
            Category.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let context = ModelContext(container)

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        let transaction = Transaction(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            category: category,
            paymentMethod: .creditCard
        )

        context.insert(category)
        context.insert(transaction)

        try context.save()

        let descriptor = FetchDescriptor<Transaction>()
        let transactions = try context.fetch(descriptor)

        XCTAssertEqual(transactions.count, 1)
        XCTAssertNotNil(transactions.first?.category)
        XCTAssertEqual(transactions.first?.category?.name, "Food")
    }
    
    func testDeletingCategoryRemovesCategory() throws {
        let container = try ModelContainer(
            for: Transaction.self,
            Category.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let context = ModelContext(container)

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        let transaction = Transaction(
            amount: 500,
            merchantName: "Lunch",
            categoryName: "Food",
            category: category,
            paymentMethod: .creditCard
        )

        context.insert(category)
        context.insert(transaction)

        try context.save()

        context.delete(category)

        try context.save()

        let categoryDescriptor = FetchDescriptor<FlowMoney.Category>()
        let categories = try context.fetch(categoryDescriptor)

        XCTAssertEqual(categories.count, 0)
    }
    
    func testTransactionHasDefaultID() {
        let transaction = Transaction(
            amount: 100,
            merchantName: "Test",
            categoryName: "Test",
            paymentMethod: .cash
        )

        XCTAssertNotEqual(transaction.id, UUID())
    }

    func testTransactionHasDefaultTimestamps() {
        let before = Date()

        let transaction = Transaction(
            amount: 100,
            merchantName: "Test",
            categoryName: "Test",
            paymentMethod: .cash
        )

        let after = Date()

        XCTAssertGreaterThanOrEqual(transaction.createdAt, before)
        XCTAssertLessThanOrEqual(transaction.createdAt, after)

        XCTAssertGreaterThanOrEqual(transaction.updatedAt, before)
        XCTAssertLessThanOrEqual(transaction.updatedAt, after)
    }

    func testTransactionSources() {
        let quickAdd = Transaction(
            amount: 100,
            merchantName: "Quick",
            categoryName: "Food",
            paymentMethod: .cash,
            source: .quickAdd
        )

        let ocr = Transaction(
            amount: 200,
            merchantName: "OCR",
            categoryName: "Food",
            paymentMethod: .cash,
            source: .ocr
        )

        let ai = Transaction(
            amount: 300,
            merchantName: "AI",
            categoryName: "Food",
            paymentMethod: .cash,
            source: .ai
        )

        XCTAssertEqual(quickAdd.source, .quickAdd)
        XCTAssertEqual(ocr.source, .ocr)
        XCTAssertEqual(ai.source, .ai)
    }
}
