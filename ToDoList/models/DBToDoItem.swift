import Foundation

struct DBToDoItem {
    var id: String
    var text: String
    var priority: String
    var deadline: Double?
    var isDone: Bool
    var createDate: Double
    var changeDate: Double?
    init(task: ToDoItem) {
        id = task.id
        text = task.text
        priority = task.priority.rawValue
        if let ddl = task.deadline?.timeIntervalSince1970 {
            deadline = Double(ddl)
        } else {
            deadline = nil
        }
        isDone = task.isDone
        createDate = Double(task.createDate.timeIntervalSince1970)
        if let chd = task.changeDate?.timeIntervalSince1970 {
            changeDate = Double(chd)
        } else {
            changeDate = nil
        }

    }
    init(id: String, text: String, priority: String, deadline: Double?, isDone: Bool, createDate: Double, changeDate: Double?) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createDate = createDate
        self.changeDate = changeDate
    }
    
    init() {
        self.id = UUID().uuidString
        self.text = ""
        self.priority = "ordinary"
        self.deadline = nil
        self.isDone = false
        self.createDate = 0
        self.changeDate = 0
    }
    
}
