import Foundation
import SQLite3

class StudentDAO {
    static let shared = StudentDAO()
    
    ///插入学生信息
    func insert(student: Student) -> Bool {
        let grade = Grade()
        let range = Range(NSRange(location: 0, length: 100))
        grade.name = student.name
        grade.studentNum = student.studentNum
        grade.mark = "\(Int.random(in: range!))"
        grade.mark2 = "\(Int.random(in: range!))"
        grade.mark3 = "\(Int.random(in: range!))"
        let sql = "insert into student(name,studentNum,school,ID,hometown,phoneNum,email) values('\(student.name)','\(student.studentNum)','\(student.school)','\(student.ID)','\(student.hometown)','\(student.phoneNum)','\(student.email)')"
        let result = DBManager.shareInstence().execSql(sql: sql) && GradeDAO.shared.insert(grade: grade)
        return result
    }
    
    ///更新学生信息
    func update(studentNum: String, student: Student) -> Bool {
        let sql = "UPDATE student SET studentNum = '\(student.studentNum)', school = '\(student.school)', ID = '\(student.ID)', hometown = '\(student.hometown)', phoneNum = '\(student.phoneNum)', email = '\(student.email)' WHERE studentNum = '\(studentNum)';"
        let result = DBManager.shareInstence().execSql(sql: sql) && GradeDAO.shared.update(oldStudentNum: studentNum, newStudentNum: student.studentNum)
        return result
    }
    
    ///删除学生
    func delete(studentNum: String) -> Bool {
        let sql = "DELETE FROM student WHERE studentNum = '\(studentNum)'"
        let result = DBManager.shareInstence().execSql(sql: sql) && GradeDAO.shared.delete(studentNum: studentNum)
        return result
    }
    
    ///根据名字查询学生信息
    func queryByName(name: String) -> [Student]? {
        let sql = "SELECT * FROM student WHERE name LIKE '%\(name)%';"
        return query(sql: sql)
    }
    
    ///查询所有学生信息
    func queryAll() -> [Student]? {
        let sql = "SELECT * FROM student ORDER BY name"
        return query(sql: sql)
    }
    
    ///查询函数
    ///sql：查询语句
    private func query(sql: String) -> [Student]? {
        var result: [Student] = []
        var stmt:OpaquePointer? = nil
        let csql = (sql.cString(using: String.Encoding.utf8))!
        if sqlite3_prepare(DBManager.shareInstence().db, csql, -1, &stmt, nil) != SQLITE_OK {
            print("未准备好")
            return nil
        }
        //准备好
        while sqlite3_step(stmt) == SQLITE_ROW {
            let name = String.init(cString: sqlite3_column_text(stmt, 0)!)
            let studentNum = String.init(cString: sqlite3_column_text(stmt, 1)!)
            let school = String.init(cString: sqlite3_column_text(stmt, 2)!)
            let ID = String.init(cString: sqlite3_column_text(stmt, 3)!)
            let hometown = String.init(cString: sqlite3_column_text(stmt, 4)!)
            let phoneNum = String.init(cString: sqlite3_column_text(stmt, 5)!)
            let email = String.init(cString: sqlite3_column_text(stmt, 6)!)
            let model = Student(name: name, studentNum: studentNum, school: school, ID: ID, hometown: hometown, phoneNum: phoneNum, email: email)
            result.append(model)
        }
        return result
    }
}
