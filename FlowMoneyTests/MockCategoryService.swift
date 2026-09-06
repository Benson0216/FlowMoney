//
//  MockCategoryService.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/6.
//

import Foundation
@testable import FlowMoney

final class MockCategoryService: CategoryServiceProtocol {

    var categories: [FlowMoney.Category] = []

    var fetchError: Error?

    var createdCategory: FlowMoney.Category?
    var createError: Error?

    var updatedCategory: FlowMoney.Category?
    var updateError: Error?

    var deletedCategory: FlowMoney.Category?
    var deleteError: Error?

    func createCategory(
        name: String,
        icon: String,
        type: TransactionType
    ) throws -> FlowMoney.Category {
        if let createError {
            throw createError
        }

        let category = Category(
            name: name,
            icon: icon,
            type: type
        )

        createdCategory = category
        categories.append(category)

        return category
    }

    func fetchCategories() throws -> [FlowMoney.Category] {
        if let fetchError {
            throw fetchError
        }

        return categories
    }

    func updateCategory(
        _ category: FlowMoney.Category,
        name: String,
        icon: String,
        type: TransactionType
    ) throws {
        if let updateError {
            throw updateError
        }

        category.name = name
        category.icon = icon
        category.type = type

        updatedCategory = category
    }

    func deleteCategory(_ category: FlowMoney.Category) throws {
        if let deleteError {
            throw deleteError
        }

        deletedCategory = category
        categories.removeAll { $0.id == category.id }
    }
}
