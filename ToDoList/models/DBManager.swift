import Foundation
import SQLite

class DBManager {
    private var db: Connection!
    private var tasks: Table!

    private var id: Expression<String>!
    private var text: Expression<String>!
    private var priority: Expression<String>!
    private var deadline: Expression<Double?>!
    private var isDone: Expression<Bool>!
    private var createDate: Expression<Double>!
    private var changeDate: Expression<Double?>!
    init () {
        do {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let dbpath = path.appendingPathComponent("myTasks.sqlite3")
            db = try Connection(dbpath.absoluteString)
            tasks = Table("tasks")
            id = Expression<String>("id")
            text = Expression<String>("text")
            priority = Expression<String>("priority")
            deadline = Expression<Double?>("deadline")
            isDone = Expression<Bool>("isDone")
            createDate = Expression<Double>("createDate")
            changeDate = Expression<Double?>("createDate")
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                           try db.run(tasks.create { (tab) in
                               tab.column(id, primaryKey: true)
                               tab.column(text)
                               tab.column(priority)
                               tab.column(deadline)
                               tab.column(isDone)
                               tab.column(createDate)
                               tab.column(changeDate)
                           })
                           UserDefaults.standard.set(true, forKey: "is_db_created")
                       }
        } catch {
            print(error)
        }
    }
    func addTask(task: ToDoItem) {
        let dbTask = DBToDoItem(task: task)
        do {
            try db.run(tasks.insert(id <- dbTask.id,
                                    text <- dbTask.text,
                                    priority <- dbTask.priority,
                                    deadline <- dbTask.deadline,
                                    isDone <- dbTask.isDone,
                                    createDate <- dbTask.createDate,
                                    changeDate <- dbTask.changeDate))
        } catch {
            print(error.localizedDescription)
        }
    }
    func getTasks() -> [ToDoItem] {
        var tasksM: [ToDoItem] = []
        tasks = tasks.order(createDate.desc)
        do {
            for task in try db.prepare(tasks) {
                let tdI = ToDoItem(dbTask: DBToDoItem(id: task[id],
                                                      text: task[text],
                                                      priority: task[priority],
                                                      deadline: task[deadline],
                                                      isDone: task[isDone],
                                                      createDate: task[createDate],
                                                      changeDate: task[changeDate]))
                tasksM.append(tdI)
            }
        } catch {
            print(error.localizedDescription)
        }
        return tasksM
    }
    func getTask(idValue: String) -> DBToDoItem {
        var dbT: DBToDoItem = DBToDoItem()
        do {
            let task: AnySequence<Row> = try db.prepare(tasks.filter(id == idValue))
            try task.forEach({ (rowValue) in
                dbT.id = try rowValue.get(id)
                dbT.text = try rowValue.get(text)
                dbT.priority = try rowValue.get(priority)
                dbT.createDate = try rowValue.get(createDate)
                dbT.isDone = try rowValue.get(isDone)
                dbT.changeDate = try rowValue.get(changeDate)
                dbT.deadline = try rowValue.get(deadline)
            })
        } catch {
            print(error)
        }
        return dbT
    }
    func upDateTask(dbTask: DBToDoItem) {
        do {
            let task: Table = tasks.filter(id == dbTask.id)
              try db.run(task.update(id <- dbTask.id,
                                     text <- dbTask.text,
                                     priority <- dbTask.priority,
                                     deadline <- dbTask.deadline,
                                     isDone <- dbTask.isDone,
                                     createDate <- dbTask.createDate,
                                     changeDate <- dbTask.changeDate))
          } catch {
              print(error.localizedDescription)
          }
    }
    func deleteTask(idValue: String) {
        do {
            let task: Table = tasks.filter(id == idValue)
            try db.run(task.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
}
