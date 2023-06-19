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
        if toDoListItems[task.id] != nil {
            toDoListItems[task.id] = task
        } else {
            toDoListItems[task.id] = task
        }
    }

    func DeleteItem(id: String) {
        if toDoListItems[id] != nil {
            toDoListItems.removeValue(forKey: id)
        } else {
            print("Task list has not item with id: \(id)")
        }
    }

    func LoadFromJSOn(filepath: String) -> Int? {
        var d: Data?
        do {
            d = try Data(contentsOf: URL(filePath: filepath))
        } catch {
            print("Error: not file with path \(filepath)")
            return nil
        }

        guard let data = d else {
            return nil
        }

        var dict: [String: Any] = [:]
        do {
            guard let dictonary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("unexpectod json structure")
                return nil
            }
            dict = dictonary

        } catch {
            print("JSON parsing error")
            return nil
        }

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
        let path_dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("ToDoItems_JSONs", isDirectory: true)
        if !FileManager.default.fileExists(atPath: path_dir.path) {
            do {
                try FileManager.default.createDirectory(atPath: path_dir.path, withIntermediateDirectories: true)
            } catch {
                print("Error creating directory")
                return nil
            }
        }

        let json_dir = path_dir.appendingPathComponent(name)
        print(json_dir)
        var dictarray: [[String: Any]] = []
        for task in toDoListItems.values {
            dictarray.append(task.getPropertyDict())
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
