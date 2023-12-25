//
//  ContentView.swift
//  iExpense
//
//  Created by Filippo on 24/12/23.
//

import SwiftUI

struct ContentView: View {
  @State private var expenses = Expenses()
  @State private var showingAddExpense = false
  @State private var typeView = ["Personal", "Business"]
  @State private var tab : Int = 0
 

  var body: some View {
    
    NavigationStack {
      TabView(selection: $tab,
              content:  {
        ListView(expenses: expenses, filter: "Personal").tabItem { Label("Personal", systemImage: "person") }.tag(0)
        ListView(expenses: expenses, filter: "Business").tabItem { Label("Business", systemImage: "newspaper") }.tag(1)
      })
        .indexViewStyle(.page)
        .navigationTitle("iExpense")
        .toolbar {
            Button("Add Expense", systemImage: "plus") {
              showingAddExpense = true
            }
        }
        
        
    }.sheet(isPresented: $showingAddExpense) {
      AddView(expenses: expenses, type: typeView[tab])
      
  }
  }
  
  
  
}

struct ExpenseItem: Identifiable, Encodable, Decodable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
  var items = [ExpenseItem]() {
    didSet {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
        }
    } 
}
  init() {
      if let savedItems = UserDefaults.standard.data(forKey: "Items") {
          if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
              items = decodedItems
              return
          }
      }

      items = []
  }
}


#Preview {
    ContentView()
}
