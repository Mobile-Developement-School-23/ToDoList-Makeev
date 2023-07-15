import CocoaLumberjackSwift
import Foundation

final class FileCache {
    let consoleLogger = DDOSLogger.sharedInstance
    let dbM = DBManager()
    private(set) var toDoListItems: [String: ToDoItem]

    init(dict: [String: ToDoItem]) {
        toDoListItems = dict
    }

    convenience init() {
        self.init(dict: [:])
    }

    func addItem(ItemToAdd task: ToDoItem) {
        toDoListItems[task.id] = task
    }

    func deleteItem(id: String) -> ToDoItem? {
        toDoListItems.removeValue(forKey: id)
    }

    func loadFromJSOn(filename: String) throws -> Int? {
        let pathDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let jsonDir = pathDir.appendingPathComponent("\(filename).json")
        let data = try Data(contentsOf: jsonDir)
        var dict: [String: Any] = [:]
        guard let dictonary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            DDLogError("unexpectod json structure")
            print("unexpectod json structure")
            return nil
        }
        dict = dictonary
        guard let toDoItemArray = dict["toDoItemArray"] as? [[String: Any]] else {
            DDLogError("unexpectod json structure ")
            print("unexpectod json structure")
            return nil
        }
        var addedCont = 0
        for dict in toDoItemArray {
            if let item = ToDoItem(dict: dict) {
                addedCont += 1
                addItem(ItemToAdd: item)
            }
        }
        DDLogDebug("Load succsesfull")
        return addedCont
    }

    func writeToJSON(NameOfJSON name: String) -> Int? {
        let pathDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let jsonDir = pathDir.appendingPathComponent("\(name).json")
        if !FileManager.default.fileExists(atPath: jsonDir.path) {
            FileManager.default.createFile(atPath: jsonDir.path, contents: nil)
        }
        print(jsonDir)
        var dictarray: [Any] = []
        for task in toDoListItems.values {
            dictarray.append(task.json)
        }
        let dict = ["toDoItemArray": dictarray]
        guard let ostream = OutputStream(url: jsonDir, append: false) else {
            fatalError("Cannot open file")
        }
        ostream.open()
        let res = JSONSerialization.writeJSONObject(dict, to: ostream, error: nil)
        if res == 0 {
            DDLogError("writing to file error")
            print("writing to file error")
            return (nil)
        }
        DDLogDebug("write succsesfull")
        return dictarray.count
    }
    func loadFromDB() -> [ToDoItem] {
        return dbM.getTasks()
    }
    func saveToDB() {
        for task in toDoListItems.values {
            dbM.addTask(task: task)
        }
    }
}
