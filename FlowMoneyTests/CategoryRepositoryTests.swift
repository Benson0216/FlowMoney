//
//  CategoryRepositoryTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/31.
//

import XCTest
import SwiftData
@testable import FlowMoney

final class CategoryRepositoryTests: XCTestCase {

    private func makeRepository() throws -> CategoryRepository {
        let container = try ModelContainer(
            for: Transaction.self,
            Category.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let context = ModelContext(container)

        return CategoryRepository(modelContext: context)
    }

    func testCreateCategory() throws {
        let repository = try makeRepository()

        let category = try repository.create(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        XCTAssertEqual(category.name, "Food")
        XCTAssertEqual(category.icon, "fork.knife")
        XCTAssertEqual(category.type, .expense)
    }

    func testFetchAllCategories() throws {
        let repository = try makeRepository()

        _ = try repository.create(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        _ = try repository.create(
            name: "Salary",
            icon: "banknote.fill",
            type: .income
        )

        let categories = try repository.fetchAll()

        XCTAssertEqual(categories.count, 2)
    }

    func testUpdateCategory() throws {
        let repository = try makeRepository()

        let category = try repository.create(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        try repository.update(
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
        let repository = try makeRepository()

        let category = try repository.create(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        try repository.delete(category)

        let categories = try repository.fetchAll()

        XCTAssertEqual(categories.count, 0)
    }
}
