import Foundation
import SwiftUI
import CoreData


struct AddView: View {
    @State private var inputText: String = ""
    @State private var descriptionText: String = ""
    @State private var deadlineDate = Date()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var todoManager: ToDoManager

    var body: some View {
        NavigationStack{
            VStack {
                TextField("タイトルを入力して下さい。", text: $inputText)
                    .font(.title)
                    .background(Color.primary)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("説明を入力して下さい。", text: $descriptionText)
                    .font(.body)
                    .background(Color.primary)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("期限", selection: $deadlineDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        dismiss()
                    }
                    Spacer()
                    Button("Save") {
                        let viewContext = PersistenceController.shared.container.viewContext
                        let newItem = ToDoItemModel(context: viewContext)

                        newItem.title = inputText
                        newItem.descriptionText = descriptionText
                        newItem.deadline = deadlineDate
                        newItem.completed = false
                        
                        todoManager.todoItems.append(newItem)
                        todoManager.saveToCoreData()
                        dismiss()
                    }
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("Add Task")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(todoManager: ToDoManager())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

