import SQLite3
import Foundation

class GradeDAO {
    static let shared = GradeDAO()
    
    ///插入成绩信息
    func insert(grade: Grade) -> Bool {
        let sql = "insert into grade(studentNum,name,mark,mark2,mark3) values('\(grade.studentNum)','\(grade.name)','\(grade.mark)','\(grade.mark2)','\(grade.mark3)')"
        let result = DBManager.shareInstence().execSql(sql: sql)
        print(result)
        return result
    }
    
    ///更新学号信息
    func update(oldStudentNum: String, newStudentNum: String) -> Bool {
        let sql = "UPDATE grade SET studentNum = '\(newStudentNum)' WHERE studentNum = '\(oldStudentNum)';"
        let result = DBManager.shareInstence().execSql(sql: sql)
        return result
    }
    
    ///删除成绩
    func delete(studentNum: String) -> Bool {
        let sql = "DELETE FROM grade WHERE studentNum = '\(studentNum)'"
        let result = DBManager.shareInstence().execSql(sql: sql)
        return result
    }
    
    ///根据学号查询学生成绩
    func queryByStudentNum(studentNum: String) -> Grade? {
        let sql = "SELECT * FROM grade WHERE studentNum = '\(studentNum)';"
        return query(sql: sql)![0]
    }
    
    func queryAll() -> [Grade]? {
        let sql = "SELECT * FROM grade;"
        return query(sql: sql)
    }
    
    ///查询函数
    ///sql：查询语句
    private func query(sql: String) -> [Grade]? {
        var result: [Grade] = []
        var stmt:OpaquePointer? = nil
        let csql = (sql.cString(using: String.Encoding.utf8))!
        if sqlite3_prepare(DBManager.shareInstence().db, csql, -1, &stmt, nil) != SQLITE_OK {
            print("未准备好")
            return nil
        }
        //准备好
        while sqlite3_step(stmt) == SQLITE_ROW {
            let studentNum = String.init(cString: sqlite3_column_text(stmt, 0)!)
            let name = String.init(cString: sqlite3_column_text(stmt, 1)!)
            let mark = String.init(cString: sqlite3_column_text(stmt, 2)!)
            let mark2 = String.init(cString: sqlite3_column_text(stmt, 3)!)
            let mark3 = String.init(cString: sqlite3_column_text(stmt, 4)!)
            let model = Grade(studentNum: studentNum, name: name, mark: mark, mark2: mark2, mark3: mark3)
            result.append(model)
        }
        return result
    }
}
