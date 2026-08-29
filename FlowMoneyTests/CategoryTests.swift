//
//  CategoryTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/29.
//

import XCTest
@testable import FlowMoney

final class CategoryTests: XCTestCase {

    func testCreateExpenseCategory() {
        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        XCTAssertEqual(category.name, "Food")
        XCTAssertEqual(category.icon, "fork.knife")
        XCTAssertEqual(category.type, .expense)
    }
    
    func testCreateIncomeCategory() {
        let category = Category(
            name: "Salary",
            icon: "banknote.fill",
            type: .income
        )

        XCTAssertEqual(category.name, "Salary")
        XCTAssertEqual(category.icon, "banknote.fill")
        XCTAssertEqual(category.type, .income)
    }
    
    func testCategoryHasDefaultIDAndCreatedAt() {
        let category = Category(
            name: "Transport",
            icon: "car.fill",
            type: .expense
        )

        XCTAssertNotEqual(category.id, UUID())
        XCTAssertLessThanOrEqual(category.createdAt, Date())
    }
}
