//
//  AddTransactionView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/8.
//

import SwiftUI

struct AddTransactionView: View {

    let viewModel: TransactionViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var amount = ""
    @State private var merchantName = ""
    @State private var categoryName = ""
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

                TextField(
                    "Category",
                    text: $categoryName
                )

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
                categoryName: categoryName,
                category: nil,
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
