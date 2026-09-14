//
//  ContentView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        let repository = TransactionRepository(
            modelContext: modelContext
        )
        
        let service = TransactionService(
            repository: repository
        )
        
        let viewModel = TransactionViewModel(
            service: service
        )
        
        let categoryRepository = CategoryRepository(
            modelContext: modelContext
        )

        let categoryService = CategoryService(
            repository: categoryRepository
        )

        let categoryViewModel = CategoryViewModel(
            service: categoryService
        )

        TransactionListView(
            viewModel: viewModel,
            categoryViewModel: categoryViewModel
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(
            for: [
                Transaction.self,
                Category.self
            ],
            inMemory: true
        )
}
