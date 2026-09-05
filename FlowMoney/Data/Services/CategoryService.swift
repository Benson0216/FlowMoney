//
//  CategoryService.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/4.
//

import Foundation

final class CategoryService {

    private let repository: CategoryRepository

    init(repository: CategoryRepository) {
        self.repository = repository
    }

    func createCategory(
        name: String,
        icon: String,
        type: TransactionType
    ) throws -> Category {
        try repository.create(
            name: name,
            icon: icon,
            type: type
        )
    }

    func fetchCategories() throws -> [Category] {
        try repository.fetchAll()
    }

    func updateCategory(
        _ category: Category,
        name: String,
        icon: String,
        type: TransactionType
    ) throws {
        try repository.update(
            category,
            name: name,
            icon: icon,
            type: type
        )
    }

    func deleteCategory(_ category: Category) throws {
        try repository.delete(category)
    }
}
