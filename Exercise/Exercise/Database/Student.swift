import Foundation

class Student {
    var name: String    //姓名
    var studentNum: String  //学号
    var school: String  //学院
    var ID: String  //身份证号
    var hometown: String    //籍贯
    var phoneNum: String //电话号码
    var email: String   //邮箱
    
    init() {
        name = ""
        studentNum = ""
        school = ""
        ID = ""
        hometown = ""
        phoneNum = ""
        email = ""
    }
    
    init(name: String, studentNum: String, school: String, ID: String, hometown: String, phoneNum: String, email: String) {
        self.name = name
        self.studentNum = studentNum
        self.school = school
        self.ID = ID
        self.hometown = hometown
        self.phoneNum = phoneNum
        self.email = email
    }
    
    
    
}
