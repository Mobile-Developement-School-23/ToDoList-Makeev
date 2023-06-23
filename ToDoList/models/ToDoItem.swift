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
}

extension ToDoItem {
    static func parse(json: Any) -> ToDoItem? {
        guard let data = json as? Data else {
            print("Error json not a Data object")
            return nil
        }
        var dictonary: [String: Any] = [:]
        do {
            guard let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("JSONSerialization failed")
                return nil
            }
            dictonary = dict
        } catch {
            print("JSON parsing error")
            return nil
        }
        return ToDoItem(dict: dictonary)
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
        let dict = getPropertyDict()
        var json = Data()
        do {
            json = try JSONSerialization.data(withJSONObject: dict)
        } catch {
            print("Error can not create json")
            return ""
        }
        return json
    }
}
