

import UIKit

class StudentTableViewController: UITableViewController {

    //判断跳转状态：添加或者编辑
    var state = ""
    //student列表
    var studentList: [Student]?
    
    var searchController: UISearchController!   //搜索控制器
    //搜索过滤后的结果集
    var searchArray:[Student] = [Student](){
        didSet  {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        //建立数据库连接
        if !DBManager.shareInstence().openDB() {
            print("数据库连接失败")
        }
        // 初始化搜索控制器
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        // 将搜索控制器集成到导航栏上
        navigationItem.searchController = self.searchController
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //刷新表格
        studentList = StudentDAO.shared.queryAll()
        tableView.reloadData()
    }

    //跳转到添加界面
    @IBAction func addStudent(_ sender: Any) {
        state = "add"
        performSegue(withIdentifier: "StudentInfo", sender: nil)
    }
    
    //跳转准备函数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! InfoViewController
        if let index = sender as? IndexPath {
            if searchController.isActive {
                destination.student = searchArray[index.row]
            } else {
                destination.student = studentList![index.row]
            }
        }
        destination.state = state
        print(state)
    }

    //表格行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchArray.count
        } else {
            if let students = studentList {
                return students.count
            } else {
                return 0
            }
        }
    }

    //表格显示内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student", for: indexPath)
        if searchController.isActive {
            cell.textLabel?.text = searchArray[indexPath.row].name
        } else {
            cell.textLabel?.text = studentList![indexPath.row].name
        }
        return cell
    }
    
    //点击表格事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        state = "edit"
        performSegue(withIdentifier: "StudentInfo", sender: indexPath)
    }
}

//搜索实现
extension StudentTableViewController: UISearchResultsUpdating {
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            searchArray.removeAll(keepingCapacity: true)
            if !searchString.isEmpty {
                for item in studentList! {
                    if item.name.contains(searchString) {
                        searchArray.append(item)
                    }
                }
            }
        }
    }
}
