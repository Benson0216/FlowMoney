//
//  CategoryEditingView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/18.
//

import SwiftUI

struct CategoryEditingView: View {
    let category: Category
    let viewModel: CategoryViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var type: TransactionType
    @State private var icon: String

    init(
        category: Category,
        viewModel: CategoryViewModel
    ) {
        self.category = category
        self.viewModel = viewModel
        _name = State(initialValue: category.name)
        _type = State(initialValue: category.type)
        _icon = State(initialValue: category.icon)
    }

    var body: some View {
        Form {
            Section("Category") {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    Text("Expense")
                        .tag(TransactionType.expense)

                    Text("Income")
                        .tag(TransactionType.income)
                }

                TextField("Icon", text: $icon)
            }

            Section {
                Button("Save") {
                    saveCategory()
                }
            }
        }
        .navigationTitle("Edit Category")
    }

    private func saveCategory() {
        do {
            try viewModel.updateCategory(
                category,
                name: name,
                icon: icon,
                type: type
            )
            dismiss()
        } catch {
            // Error handling will be added later.
        }
    }
}
