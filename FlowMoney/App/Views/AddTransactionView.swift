//
//  AddTransactionView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/8.
//

import SwiftUI

struct AddTransactionView: View {

    let viewModel: TransactionViewModel
    let categoryViewModel: CategoryViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var amount = ""
    @State private var merchantName = ""
    @State private var categoryName = ""
    @State private var selectedCategory: Category?
    @State private var paymentMethod: PaymentMethod = .creditCard
    @State private var note = ""
    @State private var date = Date.now
    @State private var type: TransactionType = .expense

    var body: some View {
        Form {
            Section("Transaction") {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)

                Picker("Type", selection: $type) {
                    Text("Expense")
                        .tag(TransactionType.expense)

                    Text("Income")
                        .tag(TransactionType.income)
                }

                DatePicker(
                    "Date",
                    selection: $date,
                    displayedComponents: .date
                )
            }

            Section("Details") {
                TextField(
                    "Merchant",
                    text: $merchantName
                )

                Picker("Category", selection: $selectedCategory) {
                    Text("None")
                        .tag(nil as Category?)

                    ForEach(categoryViewModel.categories) { category in
                        Text(category.name)
                            .tag(category as Category?)
                    }
                }

                Picker(
                    "Payment Method",
                    selection: $paymentMethod
                ) {
                    Text("Cash")
                        .tag(PaymentMethod.cash)

                    Text("Credit Card")
                        .tag(PaymentMethod.creditCard)

                    Text("Debit Card")
                        .tag(PaymentMethod.debitCard)

                    Text("Apple Pay")
                        .tag(PaymentMethod.applePay)

                    Text("Bank Transfer")
                        .tag(PaymentMethod.bankTransfer)

                    Text("Other")
                        .tag(PaymentMethod.other)
                }

                TextField(
                    "Note",
                    text: $note
                )
            }

            Section {
                Button("Save") {
                    saveTransaction()
                }
            }
        }
        .navigationTitle("Add Transaction")
        .task {
            do {
                try categoryViewModel.loadCategories()
            } catch {
                print("Failed to load categories:", error)
            }
        }
    }

    private func saveTransaction() {
        guard let amount = Decimal(string: amount) else {
            return
        }

        do {
            try viewModel.addTransaction(
                amount: amount,
                currencyCode: "TWD",
                type: type,
                date: date,
                merchantName: merchantName,
                categoryName: selectedCategory?.name ?? "",
                category: selectedCategory,
                paymentMethod: paymentMethod,
                note: note.isEmpty ? nil : note,
                source: .manual
            )

            dismiss()
        } catch {
            // Error handling will be added later.
        }
    }
}
