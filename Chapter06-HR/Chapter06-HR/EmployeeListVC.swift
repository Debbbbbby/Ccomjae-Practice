//
//  EmployeeListVC.swift
//  Chapter06-HR
//
//  Created by Doyeon on 2023/02/14.
//

import UIKit

class EmployeeListVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 테이블 뷰 하단에 뷰를 넣어 빈 셀이 표시되는 것 방지
        let dummyView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.tableFooterView = dummyView
    }
    
}
