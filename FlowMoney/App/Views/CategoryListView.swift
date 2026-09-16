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
