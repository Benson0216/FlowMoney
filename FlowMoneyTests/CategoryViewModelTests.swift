//
//  CategoryViewModelTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/6.
//

import XCTest
@testable import FlowMoney

enum CategoryViewModelTestError: Error {
    case fetchFailed
}

@MainActor
final class CategoryViewModelTests: XCTestCase {

    func testInitialCategoriesIsEmpty() {
        let mockService = MockCategoryService()
        let viewModel = CategoryViewModel(service: mockService)

        XCTAssertTrue(viewModel.categories.isEmpty)
    }
    
    func testLoadCategories() throws {
        let mockService = MockCategoryService()

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        mockService.categories = [category]

        let viewModel = CategoryViewModel(service: mockService)

        try viewModel.loadCategories()

        XCTAssertEqual(viewModel.categories.count, 1)
        XCTAssertEqual(
            viewModel.categories.first?.name,
            "Food"
        )
    }
    
    func testLoadCategoriesThrowsError() {
        let mockService = MockCategoryService()
        mockService.fetchError = CategoryViewModelTestError.fetchFailed

        let viewModel = CategoryViewModel(service: mockService)

        XCTAssertThrowsError(
            try viewModel.loadCategories()
        ) { error in
            XCTAssertTrue(error is CategoryViewModelTestError)
        }

        XCTAssertTrue(viewModel.categories.isEmpty)
    }
    
    func testAddCategory() throws {
        let mockService = MockCategoryService()
        let viewModel = CategoryViewModel(service: mockService)

        try viewModel.addCategory(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        XCTAssertEqual(viewModel.categories.count, 1)
        XCTAssertEqual(
            viewModel.categories.first?.name,
            "Food"
        )
        XCTAssertEqual(
            viewModel.categories.first?.icon,
            "fork.knife"
        )
        XCTAssertEqual(
            viewModel.categories.first?.type,
            .expense
        )
    }
    
    func testAddCategoryThrowsError() {
        let mockService = MockCategoryService()
        mockService.createError = CategoryViewModelTestError.fetchFailed

        let viewModel = CategoryViewModel(service: mockService)

        XCTAssertThrowsError(
            try viewModel.addCategory(
                name: "Food",
                icon: "fork.knife",
                type: .expense
            )
        ) { error in
            XCTAssertTrue(error is CategoryViewModelTestError)
        }

        XCTAssertTrue(viewModel.categories.isEmpty)
    }
    
    func testUpdateCategory() throws {
        let mockService = MockCategoryService()

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        mockService.categories = [category]

        let viewModel = CategoryViewModel(service: mockService)

        try viewModel.loadCategories()

        try viewModel.updateCategory(
            category,
            name: "Shopping",
            icon: "cart",
            type: .expense
        )

        XCTAssertEqual(viewModel.categories.count, 1)
        XCTAssertEqual(
            viewModel.categories.first?.name,
            "Shopping"
        )
        XCTAssertEqual(
            viewModel.categories.first?.icon,
            "cart"
        )
        XCTAssertEqual(
            viewModel.categories.first?.type,
            .expense
        )
    }
    
    func testUpdateCategoryThrowsError() throws {
        let mockService = MockCategoryService()
        mockService.updateError = CategoryViewModelTestError.fetchFailed

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        mockService.categories = [category]

        let viewModel = CategoryViewModel(service: mockService)

        try viewModel.loadCategories()

        XCTAssertThrowsError(
            try viewModel.updateCategory(
                category,
                name: "Shopping",
                icon: "cart",
                type: .expense
            )
        ) { error in
            XCTAssertTrue(error is CategoryViewModelTestError)
        }

        XCTAssertEqual(
            viewModel.categories.first?.name,
            "Food"
        )
    }
    
    func testDeleteCategory() throws {
        let mockService = MockCategoryService()

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        mockService.categories = [category]

        let viewModel = CategoryViewModel(service: mockService)

        try viewModel.loadCategories()
        try viewModel.deleteCategory(category)

        XCTAssertTrue(viewModel.categories.isEmpty)
        XCTAssertEqual(
            mockService.deletedCategory?.id,
            category.id
        )
    }
    
    func testDeleteCategoryThrowsError() throws {
        let mockService = MockCategoryService()
        mockService.deleteError = CategoryViewModelTestError.fetchFailed

        let category = Category(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        mockService.categories = [category]

        let viewModel = CategoryViewModel(service: mockService)

        try viewModel.loadCategories()

        XCTAssertThrowsError(
            try viewModel.deleteCategory(category)
        ) { error in
            XCTAssertTrue(error is CategoryViewModelTestError)
        }

        XCTAssertEqual(viewModel.categories.count, 1)
        XCTAssertEqual(
            viewModel.categories.first?.name,
            "Food"
        )
    }
}
