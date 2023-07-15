import CocoaLumberjackSwift
import Foundation

enum Priority: String {
    case unimportant
    case ordinary
    case significant
}

struct ToDoItem {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let createDate: Date
    let changeDate: Date?

    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority = .ordinary,
        deadline: Date? = nil,
        isDone: Bool,
        createDate: Date = Date(),
        changeDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createDate = createDate
        self.changeDate = changeDate
    }
}

extension ToDoItem {
    init?(dict: [String: Any]) {
        id = dict["id"] as? String ?? UUID().uuidString
        guard let txt = dict["text"] as? String else {
            return nil
        }
        text = txt
        priority = Priority(rawValue: dict["priority"] as? String ?? "ordinary") ?? Priority.ordinary
        if let ddLine = dict["deadline"] as? Double {
            deadline = Date(timeIntervalSince1970: ddLine)
        } else {
            deadline = nil
        }
        isDone = dict["isDone"] as? Bool ?? false
        createDate = Date(timeIntervalSince1970: dict["createDate"] as? Double ?? Date().timeIntervalSince1970)
        if let chDate = dict["changeDate"] as? Double {
            changeDate = Date(timeIntervalSince1970: chDate)
        } else {
            changeDate = nil
        }
    }
    init(dbTask: DBToDoItem) {
        id = dbTask.id
        text = dbTask.text
        priority = Priority(rawValue: dbTask.priority) ?? Priority.ordinary
        if let ddLine = dbTask.deadline {
            deadline = Date(timeIntervalSince1970: ddLine)
        } else {
            deadline = nil
        }
        isDone = dbTask.isDone
        createDate = Date(timeIntervalSince1970: dbTask.createDate)
        if let chDate = dbTask.changeDate {
            changeDate = Date(timeIntervalSince1970: chDate)
        } else {
            changeDate = nil
        }
    }

    static func parse(json: Any) -> ToDoItem? {
        guard let data = json as? [String: Any] else {
            DDLogError("Error json not a Data object")
            print("Error json not a Data object")
            return nil
        }
        return ToDoItem(dict: data)
    }

    func getPropertyDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = id
        dict["text"] = text
        if priority != .ordinary {
            dict["priority"] = priority.rawValue
        }
        if let deadline {
            dict["deadline"] = deadline.timeIntervalSince1970
        }
        dict["isDone"] = isDone
        dict["createDate"] = createDate.timeIntervalSince1970
        if let changeDate {
            dict["changeDate"] = changeDate.timeIntervalSince1970
        }
        return dict
    }

    var json: Any {
        getPropertyDict()
    }
}
