//
//  CategoryCreationView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/16.
//

import SwiftUI

struct CategoryCreationView: View {
    let viewModel: CategoryViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var type: TransactionType = .expense
    @State private var icon = ""

    var body: some View {
        Form {
            Section("Category") {
                TextField("Name", text: $name)
            }

            Section {
                Button("Save") {
                    saveCategory()
                }
            }

            Picker("Type", selection: $type) {
                Text("Expense")
                    .tag(TransactionType.expense)

                Text("Income")
                    .tag(TransactionType.income)
            }

            TextField("Icon", text: $icon)
        }
        .navigationTitle("Add Category")
    }

    private func saveCategory() {
        do {
            try viewModel.addCategory(
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
