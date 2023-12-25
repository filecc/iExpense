//
//  ListView.swift
//  iExpense
//
//  Created by Filippo on 24/12/23.
//

import SwiftUI

struct ListView: View {
  var expenses: Expenses
    
  var filter : String
    var body: some View {
      List {
        ForEach(expenses.items.filter { $0.type == filter}) { item in
          HStack {
                  VStack(alignment: .leading) {
                      Text(item.name)
                          .font(.headline)
                      Text(item.type)
                      .font(.footnote)
                  }

                  Spacer()
            VStack{
              Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .padding(.bottom)
                .foregroundColor(item.amount > 100 ? .red : (item.amount > 50 ? .orange : .green))
                .fontWeight(.medium)
            }
                  
              }
          }.onDelete(perform: removeItems)
          
      }
    }
  func removeItems(at offsets: IndexSet) {
    var filterdItems = expenses.items.filter { $0.type == filter}
    filterdItems.remove(atOffsets: offsets)
  }
}

#Preview {
  ListView(expenses: .init(), filter: "Personal")
}
