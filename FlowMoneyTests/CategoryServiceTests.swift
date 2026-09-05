//
//  CategoryServiceTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/4.
//

import XCTest
import SwiftData
@testable import FlowMoney

final class CategoryServiceTests: XCTestCase {

    private func makeService() throws -> CategoryService {
        let container = try ModelContainer(
            for: Transaction.self,
            Category.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )

        let context = ModelContext(container)

        let repository = CategoryRepository(
            modelContext: context
        )

        return CategoryService(
            repository: repository
        )
    }

    func testCreateCategory() throws {
        let service = try makeService()

        let category = try service.createCategory(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        XCTAssertEqual(category.name, "Food")
        XCTAssertEqual(category.icon, "fork.knife")
        XCTAssertEqual(category.type, .expense)
    }

    func testFetchCategories() throws {
        let service = try makeService()

        _ = try service.createCategory(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        _ = try service.createCategory(
            name: "Salary",
            icon: "banknote.fill",
            type: .income
        )

        let categories = try service.fetchCategories()

        XCTAssertEqual(categories.count, 2)
    }

    func testUpdateCategory() throws {
        let service = try makeService()

        let category = try service.createCategory(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        try service.updateCategory(
            category,
            name: "Dining",
            icon: "fork.knife.circle.fill",
            type: .expense
        )

        XCTAssertEqual(category.name, "Dining")
        XCTAssertEqual(category.icon, "fork.knife.circle.fill")
        XCTAssertEqual(category.type, .expense)
    }

    func testDeleteCategory() throws {
        let service = try makeService()

        let category = try service.createCategory(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        try service.deleteCategory(category)

        let categories = try service.fetchCategories()

        XCTAssertEqual(categories.count, 0)
    }

    func testCreateCategoryWithDifferentType() throws {
        let service = try makeService()

        let expenseCategory = try service.createCategory(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        let incomeCategory = try service.createCategory(
            name: "Salary",
            icon: "banknote.fill",
            type: .income
        )

        XCTAssertEqual(expenseCategory.type, .expense)
        XCTAssertEqual(incomeCategory.type, .income)
    }
}
