//
//  CategoryListViewTests.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/14.
//

import XCTest
@testable import FlowMoney

final class CategoryListViewTests: XCTestCase {

    @MainActor
    func testCategoryListViewCanBeCreated() {
        let mockService = MockCategoryService()
        let viewModel = CategoryViewModel(
            service: mockService
        )

        let view = CategoryListView(
            viewModel: viewModel
        )

        XCTAssertNotNil(view)
    }
}
