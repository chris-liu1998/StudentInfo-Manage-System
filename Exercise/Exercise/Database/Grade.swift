import Foundation

class Grade {
    var studentNum: String
    var name: String
    var mark: String
    var mark2: String
    var mark3: String
    
    init() {
        studentNum = ""
        name = ""
        mark = ""
        mark2 = ""
        mark3 = ""
    }
    
    init(studentNum: String, name: String, mark: String, mark2: String, mark3: String) {
        self.studentNum = studentNum
        self.name = name
        self.mark = mark
        self.mark2 = mark2
        self.mark3 = mark3
    }
}
