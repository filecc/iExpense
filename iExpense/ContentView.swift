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
        ListView(expenses: expenses, filter: "Personal").tag(0)
        
        ListView(expenses: expenses, filter: "Business").tag(1)
      })
        .navigationTitle("iExpense")
//        .toolbar {
//            Button("Add Expense", systemImage: "plus") {
//              showingAddExpense = true
//            }
//        }
      HStack{
        Button(action: {
          tab = 0
        }){
          VStack{
            Image(systemName: "person").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(tab != 0 ? .gray : .blue)
            Text("Personal").foregroundColor(tab != 0 ? .gray : .blue)
          }
        }
        Spacer()
        Button(action: {
          showingAddExpense = true
        })
        {
          VStack{
            Image(systemName: "plus").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
          }
        }.buttonStyle(CustomButtonStyle()).labelsHidden()
        Spacer()
        Button(action: {
          tab = 1
        }){
          VStack{
            Image(systemName: "newspaper").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(tab != 1 ? .gray : .blue)
            Text("Business").foregroundColor(tab != 1 ? .gray : .blue)
          }
        }
          
      }.padding(.horizontal, 20)
        .padding(.vertical, 10)
      
      
        
    }.sheet(isPresented: $showingAddExpense) {
      AddView(expenses: expenses, type: typeView[tab])
        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.automatic)
        .presentationBackground(.foreground)
      
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

public struct CustomButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.body.weight(.medium))
            .padding(.vertical, 10)
            .foregroundColor(Color.white)
            .frame(width: 50, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                    .fill(Color.accentColor)
                )
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}

#Preview {
    ContentView()
}
