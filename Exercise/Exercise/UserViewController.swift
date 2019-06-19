

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let account1 = Account(account: "test1", password: "123456")
        let account2 = Account(account: "test2", password: "654321")
        AccountDAO.shared.insert(account: account1)
        AccountDAO.shared.insert(account: account2)
        logoutButton.isHidden = true
        accountTextField.isEnabled = true
        passwordTextField.isEnabled = true
    }
    
    //登录
    @IBAction func loginAction(_ sender: Any) {
        var message = ""
        if let account = AccountDAO.shared.queryAccount(account: accountTextField.text!) {
            if account.password == passwordTextField.text {
                message = "登陆成功"
            } else {
                message = "密码错误"
            }
        } else {
            message = "账号不存在"
        }
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确认", style: .default) { (action) in
            if message == "登陆成功" {
                self.accountTextField.isEnabled = false
                self.passwordTextField.isEnabled = false
                self.logoutButton.isHidden = false
                self.loginButton.isHidden = true
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //注销
    @IBAction func logoutAction(_ sender: Any) {
        accountTextField.text = ""
        passwordTextField.text = ""
        accountTextField.isEnabled = true
        passwordTextField.isEnabled = true
        logoutButton.isHidden = true
        loginButton.isHidden = false
    }
    

    
}
