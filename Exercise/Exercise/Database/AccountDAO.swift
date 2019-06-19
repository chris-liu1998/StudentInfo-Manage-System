import Foundation
import SQLite3

class AccountDAO {
    static let shared = AccountDAO()

    ///插入账号信息
    func insert(account: Account) -> Bool {
        let sql = "insert into account(account,password) values('\(account.account)','\(account.password)')"
        let result = DBManager.shareInstence().execSql(sql: sql)
        return result
    }
    
    //查询
    func queryAccount(account: String) -> Account? {
        let sql = "SELECT * FROM account WHERE account = '\(account)';"
        let teachers = query(sql: sql)
        if teachers!.count == 0 {
            return nil
        } else {
            return teachers![0]
        }
    }
    
    ///查询函数
    ///sql：查询语句
    private func query(sql: String) -> [Account]? {
        var result: [Account] = []
        var stmt:OpaquePointer? = nil
        let csql = (sql.cString(using: String.Encoding.utf8))!
        if sqlite3_prepare(DBManager.shareInstence().db, csql, -1, &stmt, nil) != SQLITE_OK {
            print("未准备好")
            return nil
        }
        //准备好
        while sqlite3_step(stmt) == SQLITE_ROW {
            let account = String.init(cString: sqlite3_column_text(stmt, 0)!)
            let password = String.init(cString: sqlite3_column_text(stmt, 1)!)
            let model = Account(account: account, password: password)
            result.append(model)
        }
        return result
    }
}
