//
//  TransactionTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/26.
//

import XCTest
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
}
