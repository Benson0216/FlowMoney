//
//  CategoryServiceProtocol.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/6.
//

import Foundation

protocol CategoryServiceProtocol {

    func createCategory(
        name: String,
        icon: String,
        type: TransactionType
    ) throws -> Category

    func fetchCategories() throws -> [Category]

    func updateCategory(
        _ category: Category,
        name: String,
        icon: String,
        type: TransactionType
    ) throws

    func deleteCategory(
        _ category: Category
    ) throws
}
