//
//  CategoryEditingViewTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/18.
//

import XCTest
import SwiftUI
@testable import FlowMoney

@MainActor
final class CategoryEditingViewTests: XCTestCase {

    func testCategoryEditingViewCanBeCreated() {
        let mockService = MockCategoryService()
        let viewModel = CategoryViewModel(service: mockService)

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        let view = CategoryEditingView(
            category: category,
            viewModel: viewModel
        )

        XCTAssertNotNil(view)
    }

    func testUpdateCategoryUpdatesExistingCategory() throws {
        let mockService = MockCategoryService()
        let viewModel = CategoryViewModel(service: mockService)

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        try viewModel.addCategory(
            name: category.name,
            icon: category.icon,
            type: category.type
        )

        let existingCategory = try XCTUnwrap(viewModel.categories.first)

        try viewModel.updateCategory(
            existingCategory,
            name: "Transportation",
            icon: "car.fill",
            type: .expense
        )

        XCTAssertEqual(existingCategory.name, "Transportation")
        XCTAssertEqual(existingCategory.icon, "car.fill")
        XCTAssertEqual(existingCategory.type, .expense)
    }
}
