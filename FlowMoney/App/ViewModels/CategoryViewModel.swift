//
//  CategoryViewModel.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/6.
//

import Foundation
import Observation

@MainActor
@Observable
final class CategoryViewModel {

    var categories: [Category] = []

    private let service: CategoryServiceProtocol

    init(service: CategoryServiceProtocol) {
        self.service = service
    }
    
    func loadCategories() throws {
        categories = try service.fetchCategories()
    }
    
    func addCategory(
        name: String,
        icon: String,
        type: TransactionType
    ) throws {
        let category = try service.createCategory(
            name: name,
            icon: icon,
            type: type
        )

        categories.append(category)
    }
    
    func updateCategory(
        _ category: Category,
        name: String,
        icon: String,
        type: TransactionType
    ) throws {
        try service.updateCategory(
            category,
            name: name,
            icon: icon,
            type: type
        )
    }
    
    func deleteCategory(_ category: Category) throws {
        try service.deleteCategory(category)

        categories.removeAll { $0.id == category.id }
    }
}
