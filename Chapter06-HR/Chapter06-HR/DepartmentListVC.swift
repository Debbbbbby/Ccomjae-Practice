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
        self.departList = self.departDAO.findAll() // 기존 정보 불러오기
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
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // indexPath 매개변수가 가리키는 행에 대한 데이터 읽어오기
        let rowData = self.departList[indexPath.row]
        
        // 셀 객체를 생성하고 데이터를 배치한다d
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        cell?.textLabel?.text = rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        cell?.detailTextLabel?.text = rowData.departAddr
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell!
    }
    
    /// 목록 편집 형식을 결정하는 함수 (삭제 / 수정)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    /// 편집 모드에서 DELETE 버튼을 클릭했을 때 호출되는 메서드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 삭제할 행의 departCd를 구한다
        let departCd = self.departList[indexPath.row].departCd
        
        // DB에서, 데이터 소스에서, 테이블 뷰에서 차례로 삭제한다
        if departDAO.remove(departCd: departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: @IBAction
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "신규 부서 등록",
                                      message: "신규 부서를 등록해 주세요",
                                      preferredStyle: .alert)

        // 부서명 및 주소 입력용 텍스트 필드 추가
        alert.addTextField() { (tf) in tf.placeholder = "부서명" }
        alert.addTextField() { (tf) in tf.placeholder = "주소" }

        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in // 확인 버튼
            // 부서 등록 로직
            let title = alert.textFields?[0].text // 부서명
            let addr = alert.textFields?[1].text // 주소

            if self.departDAO.create(title: title!, addr: addr!) {
                // 신규 부서가 등록되면 DB에서 목록을 다시 읽어온 후, 테이블을 갱신해 준다.
                self.departList = self.departDAO.findAll()
                self.tableView.reloadData()
                
                // 내비게이션 타이틀에도 변경된 부서 정보를 반영한다
                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "부서 목록 \n" + " 총 \(self.departList.count) 개"
            }
        })
        self.present(alert, animated: false)
    }
    
}
