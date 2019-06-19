import Foundation

class Account {
    var account: String
    var password: String
    
    init() {
        account = ""
        password = ""
    }
    
    init(account: String, password: String) {
        self.account = account
        self.password = password
    }
}
