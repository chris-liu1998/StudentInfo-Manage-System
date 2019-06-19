import UIKit
import SQLite3

class DBManager: NSObject {
    var db:OpaquePointer? = nil
    //数据库单例管理对象
    private static let instance = DBManager()
    class func shareInstence() -> DBManager {
        return instance
    }
    
    func openDB() -> Bool {
        let state = sqlite3_open(dataFilePath(), &db)
        if state != SQLITE_OK{
            print("打开数据库失败")
            return false
        }
        //创建表
        return creatTableStudent() && createTableGrade() && createTableAccount()
    }
    
    ///获取数据库文件路径
    private func dataFilePath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url: String?
        url = ""
        do {
            try url = urls.first?.appendingPathComponent("data1.plist").path
        } catch {
            print("Error is \(error)")
        }
        print(url!)
        return url!
    }
    
    //学生表
    func creatTableStudent() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS 'student' ("
        + "'name' char(10) NOT NULL,"
        + "'studentNum' char(13) NOT NULL,"
        + "'school' char(15) NOT NULL,"
        + "'ID' char(18) NOT NULL,"
        + "'hometown' char(15) DEFAULT NULL,"
        + "'phoneNum' char(11) DEFAULT NULL,"
        + "'email' char(25) DEFAULT NULL,"
        + "PRIMARY KEY ('studentNum','ID')"
        + ");"
        return execSql(sql: sql)
    }
    
    //成绩表
    func createTableGrade() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS 'grade' ("
            + "'studentNum' char(13) NOT NULL,"
            + "'name' char(15) NOT NULL,"
            + "'mark' char(2) DEFAULT NULL,"
            + "'mark2' char(2) DEFAULT NULL,"
            + "'mark3' char(2) DEFAULT NULL,"
            + "PRIMARY KEY ('studentNum'),"
            + "CONSTRAINT 'grade_ibfk_1' FOREIGN KEY ('studentNum') REFERENCES 'student' ('studentNum')"
            + ");"
        return execSql(sql: sql)
    }
    
    //账号表
    func createTableAccount() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS 'account' ("
            + "'account' char(15) NOT NULL,"
            + "'password' char(20) NOT NULL,"
            + "PRIMARY KEY ('account')"
            + ");"
        return execSql(sql: sql)
    }
    
    func execSql(sql:String) -> Bool {
        let csql = sql.cString(using: String.Encoding.utf8)
        return sqlite3_exec(db, csql, nil, nil, nil) == SQLITE_OK
    }
}
