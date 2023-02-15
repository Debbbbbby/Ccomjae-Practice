//
//  DepartmentListVC.swift
//  Chapter06-HR
//
//  Created by Doyeon on 2023/02/14.
//

import UIKit

class DepartmentListVC: UITableViewController {
    
    // MARK: - Properties
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]! // 데이터 소스용 멤버 변수
    let departDAO = DepartmentDAO() // SQL 처리 담당 DAO 객체
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.initUI()
    }
    
    /// UI초기화
    func initUI() {
        
        // 1. 내비게이션 타이틀용 레이블 속성 설정
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 18)
        navTitle.text = "부서 목록 \n" + " 총 \(self.departList.count) 개"
        
        // 2. 내비게이션 바 UI 설정
        self.navigationItem.titleView = navTitle
        self.navigationItem.leftBarButtonItem = self.editButtonItem // 편집 버튼 추가
        
        // 3. 셀을 스와이프했을 때 편집 모드가 되도록 설정
        self.tableView.allowsSelectionDuringEditing = true
        
        // 테이블 뷰 하단에 뷰를 넣어 빈 셀이 표시되는 것 방지
        let dummyView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.tableFooterView = dummyView
    }
    
    // MARK: - Methods
    
}
