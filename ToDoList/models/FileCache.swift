import Foundation

final class FileCache {
    private(set) var toDoListItems: [String: ToDoItem]

    init(dict: [String: ToDoItem]) {
        toDoListItems = dict
    }

    convenience init() {
        self.init(dict: [:])
    }

    func AddItem(ItemToAdd task: ToDoItem) {
        toDoListItems[task.id] = task
    }

    func DeleteItem(id: String) -> ToDoItem? {
        toDoListItems.removeValue(forKey: id)
    }

    func LoadFromJSOn(filename: String) throws -> Int? {
        let path_dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let json_dir = path_dir.appendingPathComponent("\(filename).json")
        let data = try Data(contentsOf: json_dir)
        var dict: [String: Any] = [:]
        guard let dictonary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("unexpectod json structure")
            return nil
        }
        dict = dictonary
        guard let toDoItemArray = dict["toDoItemArray"] as? [[String: Any]] else {
            print("unexpectod json structure")
            return nil
        }
        var addedCont = 0
        for dict in toDoItemArray {
            if let item = ToDoItem(dict: dict) {
                addedCont += 1
                AddItem(ItemToAdd: item)
            }
        }
        return addedCont
    }

    func WriteToJSON(NameOfJSON name: String) -> Int? {
        let path_dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let json_dir = path_dir.appendingPathComponent("\(name).json")
        if !FileManager.default.fileExists(atPath: json_dir.path) {
            FileManager.default.createFile(atPath: json_dir.path, contents: nil)
        }
        print(json_dir)
        var dictarray: [Any] = []
        for task in toDoListItems.values {
            dictarray.append(task.json)
        }
        let dict = ["toDoItemArray": dictarray]
        guard let ostream = OutputStream(url: json_dir, append: false) else {
            fatalError("Cannot open file")
        }
        ostream.open()
        let res = JSONSerialization.writeJSONObject(dict, to: ostream, error: nil)
        if res == 0 {
            print("writing to file error")
            return (nil)
        }
        return dictarray.count
    }
}
