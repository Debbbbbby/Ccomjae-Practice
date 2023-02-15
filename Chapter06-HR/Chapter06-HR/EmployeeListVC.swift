//
//  EmployeeListVC.swift
//  Chapter06-HR
//
//  Created by Doyeon on 2023/02/14.
//

import UIKit

class EmployeeListVC: UITableViewController {
    
    // MARK: - Properties
    var empList: [EmployeeVO]! // 데이터 소스용 멤버 변수
    var empDAO = EmployeeDAO() // SQL 처리 담당 DAO 객체
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.empList = self.empDAO.findAll() // 기존 정보 불러오기
        self.initUI()
    }
    
    /// UI초기화
    func initUI() {
        
        // 1. 내비게이션 타이틀용 레이블 속성 설정
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 18)
        navTitle.text = "사원 목록 \n" + " 총 \(self.empList.count) 개"
        
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
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.empList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
        
        cell?.textLabel?.text = rowData.empName + "(\(rowData.stateCd.desc()))"
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        cell?.detailTextLabel?.text = rowData.departTitle
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell!
    }
    
    // MARK: @IBAction
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "사원 등록",
                                      message: "사원 정보를 입력해 주세요",
                                      preferredStyle: .alert)
        
        alert.addTextField() { (tf) in tf.placeholder = "사원명" }
        
        // contentViewController 영역에 부서 선택 피커 뷰 삽입
        let pickerVC = DepartPickerVC()
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in // 확인 버튼
            // 사원 등록 로직
            // 알림창의 입력 필드에서 값을 읽어온다
            var param = EmployeeVO()
            param.departCd = pickerVC.selectedDepartCd
            param.empName = (alert.textFields?[0].text)!
            
            // 가입일 오늘로 설정
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())
            
            param.stateCd = EmpStateType.ING
            
            if self.empDAO.create(param: param) {
                self.empList = self.empDAO.findAll()
                self.tableView.reloadData()

                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "사원 목록 \n" + " 총 \(self.empList.count) 개"
            }
        })
        self.present(alert, animated: false)
    }
}
