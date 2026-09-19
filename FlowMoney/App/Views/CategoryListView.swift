//
//  CategoryListView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/14.
//

import SwiftUI

struct CategoryListView: View {

    let viewModel: CategoryViewModel

    var body: some View {
        NavigationStack {
            List {
                if viewModel.categories.isEmpty {
                    ContentUnavailableView(
                        "No Categories",
                        systemImage: "folder"
                    )
                } else {
                    ForEach(viewModel.categories) { category in
                        NavigationLink {
                            CategoryEditingView(
                                category: category,
                                viewModel: viewModel
                            )
                        } label: {
                            VStack(alignment: .leading) {
                                Text(category.name)
                                Text(
                                    category.type == .income
                                        ? "Income"
                                        : "Expense"
                                )
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let category = viewModel.categories[index]

                            do {
                                try viewModel.deleteCategory(category)
                            } catch {
                                // Error handling will be added later.
                            }
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CategoryCreationView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                try? viewModel.loadCategories()
            }
        }
    }
}
