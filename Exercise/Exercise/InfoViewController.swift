

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var studentNumber: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var home: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var state = ""
    var student: Student?
    override func viewDidLoad() {
        if state == "edit" {
            name.text = student!.name
            studentNumber.text = student!.studentNum
            school.text = student!.school
            ID.text = student!.ID
            home.text = student!.hometown
            phone.text = student!.phoneNum
            email.text = student!.email
        }
        super.viewDidLoad()
    }
    
    //判断当前是添加还是编辑来显示不同的按钮
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        if state == "add" {
            textfieldModChange(mod: true)
            name.isEnabled = true
        } else {
            textfieldModChange(mod: false)
            name.isEnabled = false
        }
    }
    
    //编辑
    @IBAction func editAction(_ sender: Any) {
        editButton.isHidden = true
        deleteButton.isHidden = true
        textfieldModChange(mod: true)
    }
    
    //删除
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "警告", message: "确认删除？", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "确认", style: .destructive) { (action) in
            if !StudentDAO.shared.delete(studentNum: self.student!.studentNum) {
                print("删除失败")
            }
            //跳回主界面
            let viewController = self.navigationController?.viewControllers[0]
            self.navigationController?.popToViewController(viewController!, animated: true)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true)
    }
    
    //保存
    @IBAction func saveAction(_ sender: Any) {
        let info = Student(name: name.text!, studentNum: studentNumber.text!, school: school.text!, ID: ID.text!, hometown: home.text!, phoneNum: phone.text!, email: email.text!)
        //修改事件
        if state == "edit" {
            if !StudentDAO.shared.update(studentNum: student!.studentNum, student: info) {
                print("修改失败")
            }
            editButton.isHidden = false
            deleteButton.isHidden = false
            textfieldModChange(mod: false)
        //添加事件
        } else if state == "add" {
            var message = ""
            if !StudentDAO.shared.insert(student: info) {
                message = "添加失败"
            } else {
                message = "添加成功"
            }
            let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "确认", style: .default) { (action) in
                let viewController = self.navigationController?.viewControllers[0]
                self.navigationController?.popToViewController(viewController!, animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
        
    }
    
    //textfield编辑模式
    func textfieldModChange(mod: Bool) {
        studentNumber.isEnabled = mod
        school.isEnabled = mod
        ID.isEnabled = mod
        home.isEnabled = mod
        phone.isEnabled = mod
        email.isEnabled = mod
        editButton.isHidden = mod
        deleteButton.isHidden = mod
        saveButton.isHidden = !mod
    }
    
}
