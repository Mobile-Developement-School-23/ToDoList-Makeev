import SwiftUI





struct TaskListView: View {
    let tasks: [ToDoItem]
    let done: Int
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Color.backPrimary
                            .ignoresSafeArea()
                    VStack {
                        HStack {
                            Text("Выполнено — \(done)")
                                .font(.subHead)
                                .foregroundColor(.lablelTertiary)
                            Spacer()
                            Button("Скрыть") {
                                print("hide")
                            }
                        }
                        .padding([.leading, .trailing], 16)
                        List(tasks, id: \.id) { task in
                            TaskRow(isDone: task.isDone, importance: task.priority, deadline: task.deadline, text: task.text)
                                .listRowSeparatorTint(Color.SuppSeparator)
                            
                        }
                        .scrollContentBackground(.hidden)
                        Spacer()
                    }
                    .padding([.leading, .trailing], 16)
                    .navigationTitle("Мои дела")
                }
            }
            VStack {
                Spacer()
                Button {
                    print("+")
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                }
            }
        }
    }
}



struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(tasks: [ToDoItem(text: "hello", priority: .significant, deadline: Date(timeIntervalSince1970: 12300),isDone: false),
                             ToDoItem(text: "My task", isDone: true),
                             ToDoItem(text: "Do homework", isDone: false),
                             ToDoItem(text: "clean room", isDone: false),
                             ToDoItem(text: "walk outside", isDone: false)], done: 3)
    }
}
