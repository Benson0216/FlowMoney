//
//  TransactionDetailView.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/9/10.
//

import SwiftUI

struct TransactionDetailView: View {

    let transaction: Transaction
    let viewModel: TransactionViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var amount: String
    @State private var merchantName: String
    @State private var type: TransactionType
    @State private var date: Date
    @State private var categoryName: String
    @State private var paymentMethod: PaymentMethod
    @State private var note: String

    init(
        transaction: Transaction,
        viewModel: TransactionViewModel
    ) {
        self.transaction = transaction
        self.viewModel = viewModel

        _amount = State(
            initialValue: transaction.amount.description
        )

        _merchantName = State(
            initialValue: transaction.merchantName
        )
        
        _type = State(
            initialValue: transaction.type
        )

        _date = State(
            initialValue: transaction.date
        )
        
        _categoryName = State(
            initialValue: transaction.categoryName
        )
        
        _paymentMethod = State(
            initialValue: transaction.paymentMethod
        )
        
        _note = State(
            initialValue: transaction.note ?? ""
        )
    }

    var body: some View {
        Form {
            Section("Transaction") {
                TextField(
                    "Amount",
                    text: $amount
                )
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
        .navigationTitle("Edit Transaction")
    }

    private func saveTransaction() {
        guard let amount = Decimal(string: amount) else {
            return
        }

        do {
            try viewModel.updateTransaction(
                transaction,
                amount: amount,
                currencyCode: transaction.currencyCode,
                type: type,
                date: date,
                merchantName: merchantName,
                categoryName: categoryName,
                category: transaction.category,
                paymentMethod: paymentMethod,
                note: note.isEmpty ? nil : note,
                source: transaction.source
            )

            dismiss()
        } catch {
            // Error handling will be added later.
        }
    }
}
