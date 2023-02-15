//
//  DepartmentInfoVC.swift
//  Chapter06-HR
//
//  Created by Doyeon on 2023/02/15.
//

import UIKit

class DepartmentInfoVC: UITableViewController {
    
    typealias DepartRecord = (departCd: Int, departTitle: String, departAddr: String)
    
    // MARK: - Properties
    var departCd: Int!
    
    let departDAO = DepartmentDAO()
    let empDAO = EmployeeDAO()
    
    var departInfo: DepartRecord!
    var empList: [EmployeeVO]!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.departInfo = self.departDAO.getOne(departCd: self.departCd)
        self.empList = self.empDAO.find(departCd: self.departCd)
        
        self.navigationItem.title = "\(self.departInfo.departTitle)"
    }
}
