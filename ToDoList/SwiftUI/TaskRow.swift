import SwiftUI

struct TaskRow: View {
    let isDone: Bool
    let importance: Priority
    let deadline: Date?
    let text: String
    let calendar = Calendar.current
    var body: some View {
        HStack {
            if isDone {
                Image("radioButtonDone")
                    .padding([.leading,.trailing], 12)
            } else {
                switch importance {
                case .significant:
                    Image("radioButtonImportant")
                        .padding([.leading,.trailing], 12)
                default:
                    Image("radioButtonCommon")
                        .padding([.leading,.trailing], 12)
                }
            }
            VStack {
                if importance == .significant {
                    HStack {
                        Image("important")
                        Text(text)
                        Spacer()
                    }
                } else {
                    HStack {
                        Text(text)
                        Spacer()
                    }
                }
                if let deadline {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.lablelTertiary)
                        Text("\(getStr(date: deadline))")
                            .font(.subHead)
                            .foregroundColor(.lablelTertiary)
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
}

func getStr(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d LLLL"
    return dateFormatter.string(from: date)
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(isDone: false, importance: .significant, deadline: Date(timeIntervalSince1970: 1230000), text: "hello")
    }
}
