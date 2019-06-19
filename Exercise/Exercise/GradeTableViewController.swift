

import UIKit

class GradeTableViewController: UITableViewController {

    var studentList: [Student]?
    var searchController: UISearchController!   //搜索控制器
    //搜索过滤后的结果集
    var searchArray:[Student] = [Student](){
        didSet  {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化搜索控制器
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        // 将搜索控制器集成到导航栏上
        navigationItem.searchController = self.searchController
    }

    //获取所有数据
    override func viewWillAppear(_ animated: Bool) {
        studentList = StudentDAO.shared.queryAll()
    }

    //表格行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchArray.count
        } else {
            return 0
        }
    }

    //定制表格内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "grade", for: indexPath) as! GradeCell
        let grade = GradeDAO.shared.queryByStudentNum(studentNum: searchArray[indexPath.row].studentNum)
        cell.name.text = grade?.name
        cell.studentNum.text = grade?.studentNum
        cell.mark.text = grade?.mark
        cell.mark2.text = grade?.mark2
        cell.mark3.text = grade?.mark3
        return cell
    }

}

//搜索函数
extension GradeTableViewController: UISearchResultsUpdating {
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text, let list = studentList {
            searchArray.removeAll(keepingCapacity: true)
            if !searchString.isEmpty {
                for item in list {
                    if item.name.contains(searchString) {
                        searchArray.append(item)
                    }
                }
            }
        }
    }
}
