//
//  ContentView.swift
//  sample3
//
//  Created by 渡邊 翔矢 on 2023/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var newItem: String = ""
    @State private var items: [String] = UserDefaults.standard.stringArray(forKey: "ToDoList") ?? []
    
    var body: some View {
        VStack {
            TextField("新しいToDoを追加", text: $newItem)
                .padding()
            Button("追加") {
                addItem()
            }
            List(items, id: \.self) { item in
                Text(item)
            }
        }
        .padding()
    }
    
    private func addItem() {
        if !newItem.isEmpty {
            items.append(newItem)
            UserDefaults.standard.set(items, forKey: "ToDoList")
            newItem = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
