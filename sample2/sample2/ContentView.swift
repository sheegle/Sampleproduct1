// ToDoManager.swift

import SwiftUI
import CoreData

class ToDoManager: ObservableObject {
    @Published var todoItems: [ToDoItemModel] = []
    
    init() {
        self.todoItems = loadFromCoreData()
    }
    
    func saveToCoreData() {  // internalアクセス修飾子を追加
        let viewContext = PersistenceController.shared.container.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func loadFromCoreData() -> [ToDoItemModel] {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<ToDoItemModel> = ToDoItemModel.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            if let errorMessage = error.userInfo["NSDetailedErrors"] as? [String: AnyObject] {
                print("Core Data Error: Unresolved error \(error), \(errorMessage)")
            } else {
                print("Core Data Error: Unresolved error \(error), \(error.userInfo)")
            }
            return []
        } catch {
            fatalError("Unexpected error: \(error)")
        }
    }

}

struct ContentView: View {
    @State private var todoManager = ToDoManager()  // ToDoManagerを使うように変更
    @State private var completed = false
    @State private var isShowAddView = false
    
    init(todoManager: ToDoManager) {
        self.todoManager = todoManager
    }
    

    var body: some View {
        NavigationView {
            VStack {
                if todoManager.todoItems.isEmpty {
                    Image(systemName: "paintbrush")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                    Text("＋ボタンを押してタスクを追加しよう")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(todoManager.todoItems) { item in
                            Button {
                                todoManager.todoItems[todoManager.todoItems.firstIndex(of: item)!].completed.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: item.completed ?"checkmark.circle.fill" :"circle")
                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                            .font(.title)
                                        Text("期限: \(formattedDeadline(for: item.deadline))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("説明: \(item.description)")
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                        .onDelete { indexSet in
                            todoManager.todoItems.removeAll { indexSet.contains(todoManager.todoItems.firstIndex(of: $0)! )
                            }
                        }
                    }
                }
            }
            .navigationTitle("ToDo List")
            .toolbar{
                Button("+"){
                    isShowAddView = true
                }
            }
            .sheet(isPresented: $isShowAddView) {
                AddView(todoManager: todoManager)
            }
        }
    }
    
    private func formattedDeadline(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(todoManager: ToDoManager())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDisplayName("No Tasks")
    }
}


