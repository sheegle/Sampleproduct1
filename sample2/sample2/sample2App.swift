//
//  sample2App.swift
//  sample2
//
//  Created by 渡邊 翔矢 on 2023/12/22.
//

// UserDefaultsApp.swift

import SwiftUI

@main
struct UserDefaultsApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var todoManager = ToDoManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(todoManager: todoManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
