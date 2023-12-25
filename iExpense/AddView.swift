//
//  AddView.swift
//  iExpense
//
//  Created by Filippo on 24/12/23.
//

import SwiftUI

struct AddView: View {
  @Environment(\.dismiss) private var dismiss
    var expenses: Expenses
    
    @State private var name = ""
    @State var type : String
    @State private var amount = 0.0

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
              if (amount <= 0) {
                Button("Close"){
                  dismiss()
                }
              } else {
                Button("Save") {
                  if(amount == 0.0) { return }
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
              }
              
        }
      }
    }
}

#Preview {
  AddView(expenses: Expenses(), type: "Personal")
}
