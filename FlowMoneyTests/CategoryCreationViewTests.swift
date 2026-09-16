//
//  CategoryCreationViewTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/16.
//

import XCTest
import SwiftUI
@testable import FlowMoney

@MainActor
final class CategoryCreationViewTests: XCTestCase {

    func testCategoryCreationViewCanBeCreated() {
        let mockService = MockCategoryService()
        let viewModel = CategoryViewModel(service: mockService)

        let view = CategoryCreationView(
            viewModel: viewModel
        )

        XCTAssertNotNil(view)
    }

    func testSaveCreatesCategory() throws {
        let mockService = MockCategoryService()
        let viewModel = CategoryViewModel(service: mockService)

        try viewModel.addCategory(
            name: "Food",
            icon: "fork.knife",
            type: .expense
        )

        XCTAssertEqual(viewModel.categories.count, 1)
        XCTAssertEqual(viewModel.categories.first?.name, "Food")
        XCTAssertEqual(viewModel.categories.first?.icon, "fork.knife")
        XCTAssertEqual(viewModel.categories.first?.type, .expense)
    }
}
