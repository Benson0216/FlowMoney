//
//  CategoryRepository.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/31.
//

import Foundation
import SwiftData

final class CategoryRepository {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func create(
        name: String,
        icon: String,
        type: TransactionType
    ) throws -> Category {
        let category = Category(
            name: name,
            icon: icon,
            type: type
        )

        modelContext.insert(category)
        try modelContext.save()

        return category
    }

    func fetchAll() throws -> [Category] {
        let descriptor = FetchDescriptor<Category>()

        return try modelContext.fetch(descriptor)
    }

    func update(
        _ category: Category,
        name: String,
        icon: String,
        type: TransactionType
    ) throws {
        category.name = name
        category.icon = icon
        category.type = type

        try modelContext.save()
    }

    func delete(_ category: Category) throws {
        modelContext.delete(category)
        try modelContext.save()
    }
}
