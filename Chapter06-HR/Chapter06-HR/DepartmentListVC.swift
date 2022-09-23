//
//  DepartmentListVCTableViewController.swift
//  Chapter06-HR
//
//  Created by Debby on 2022/09/21.
//

import UIKit

class DepartmentListVC: UITableViewController {
        
    // MARK: - Properties
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]! // 데이터 소스용 멤버 변수
    let departDAO = DepartmentDAO() // SQLite 처리를 담당할 DAO 객체
    
    // MARK: - init
    // UI 초기화 함수
    func initUI() {
        // 1. 내비게이션 타이틀용 레이블 속성 설정
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "부서 목록 \n" + "총 \(self.departList.count) 개"
        
        // 2. 내비게이션 바 UI 설정
        self.navigationItem.titleView = navTitle
        self.navigationItem.leftBarButtonItem = self.editButtonItem // 편집 버튼 추가
        
        // 3. 셀을 스와이프했을 때 편집 모드가 되도록 설정
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        self.departList = self.departDAO.find() // 기존 저장된 부서 정보 가져오기
        self.initUI()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.departList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // indexPath 매개변수가 가리키는 행에 대한 데이터를 읽어온다.
        let rowData = self.departList[indexPath.row]
        
        // 셀 객체를 생성하고 데이터를 배치한다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        
        cell?.textLabel?.text = rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell?.detailTextLabel?.text = rowData.departAddr
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell!
    }
    
    /// 목록 편집 형식을 결정하는 함수 (삭제 / 수정)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    /** editingStyleForRowAt의 반환값으로 사용되는 UITableViewCell.EditingStyle 열거형은 세 가지 타입의 값을 가진다.
        .inser - 삽입 모드 / .delete - 삭제 모드 / none - 편집 모드 제공하지 않음
        위 메서드를 오버라이드 하지 않으면 상위 메서드를 통해 .delete가 반환되기 때문에 단순 일괄 삭제 기능이라면 필요없다.
        하지만 개별 수정 기능을 제공하려면 indexPath.row 값을 switch case 로 위 세가지 값 중 하나로 반환 되도록 설정해 줄 필요가 있다.
     */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 1. 삭제할 행의 DepartCd 를 구한다.
        let departCd = self.departList[indexPath.row].departCd
    
        // 2. DB에서, 데이터 소스에서, 테이블 뷰에서 차례대로 삭제한다.
        if departDAO.remove(departCd: departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /// 부서를 선택했을 때 현재의 화면으로 이동하는 코드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 화면 이동 시 함께 전달할 부서 코드
        let departCd = self.departList[indexPath.row].departCd
        
        // 이동할 대상 뷰 컨트롤러의 인스턴스
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "DEPART_INFO")
        
        if let _infoVC = infoVC as? DepartmentInfoVC {
            // 부서 코드를 전달한 다음 푸시 방식으로 화면 이동
            _infoVC.departCd = departCd
            self.navigationController?.pushViewController(_infoVC, animated: true )
        }
    }
    
    // MARK: - Navigation
    @IBAction func add(_ sender: Any) {
        // 비즈니스 로직
        let alert = UIAlertController(title: "신규 부서 등록", message: "신규 부서를 등록해 주세요", preferredStyle: .alert)
        
        // 부서명 및 주소 입력용 텍스트 필드 추가
        alert.addTextField() { (tf) in tf.placeholder = "부서명" }
        alert.addTextField() { (tf) in tf.placeholder = "주소" }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel)) // 취소 버튼
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in // 확인 버튼
            // 부서 등록 로직
            let title = alert.textFields?[0].text // 부서명
            let addr = alert.textFields?[1].text // 부서 주소
            
            if self.departDAO.create(title: title!, addr: addr!){
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
                
                // 내비게이션 타이틀에도 변경된 부서 정보를 반영한다.
                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "부서 목록 \n" + "총 \(self.departList.count) 개"
            }
        })
        self.present(alert, animated: false)
    }
    
}
