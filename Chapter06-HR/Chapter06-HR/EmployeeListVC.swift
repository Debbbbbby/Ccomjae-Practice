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
    var loadingImg: UIImageView! // 새로고침 컨트롤에 들어갈 이미지 뷰
    var bgCircle: UIView! // 임계점에 도달했을 때 나타날 배경 뷰, 노란 원 상태
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.empList = self.empDAO.find() // 기존 정보 불러오기
        self.initUI()
        
        // 당겨서 새로고침
        self.refreshControl = UIRefreshControl()
        //self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        // 로딩 이미지 초기화 & 중앙 정렬
        self.loadingImg = UIImageView(image: UIImage(named: "refresh"))
        self.loadingImg.center.x = (self.refreshControl?.frame.width)! / 2
        
        self.refreshControl?.tintColor = .clear // 기존 로딩 컬러 투명하게 설정
        self.refreshControl?.addSubview(self.loadingImg)
        
        // 배경 뷰 초기화 및 노란 원 형태 속성 설정
        self.bgCircle = UIView()
        self.bgCircle.backgroundColor = .yellow
        self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2

        // 배경 뷰를 refreshControl 객체에 추가하고, 로딩 이미지를 제일 위로 올림
        self.refreshControl?.addSubview(self.bgCircle)
        self.refreshControl?.bringSubviewToFront(self.loadingImg)
    }
    
    /// UI초기화
    func initUI() {
        self.tableView.delegate = self
        
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
        cell?.textLabel?.textColor = .black
        
        cell?.detailTextLabel?.text = rowData.departTitle
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.textColor = .black
        
        return cell!
    }
    
    /// 목록 편집 형식을 결정하는 메서드(삽입 / 삭제)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    /// 목록 편집 버튼을 클릭했을 때 호출되는 메서드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let empCd = self.empList[indexPath.row].empCd
        if empDAO.remove(empCd: empCd) {
            self.empList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: Scroll View Delegate
    /// 스크롤이 발생할 때마다 처리할 내용
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 당긴 거리를 계산하는 공식!✨✨✨✨✨
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        
        // center.y 좌표를 당긴 거리만큼 수정
        self.loadingImg.center.y = distance / 2
        
        // 당긴 거리를 회전 각도로 반환하여 로딩 이미지에 설정한다.
        let ts = CGAffineTransform(rotationAngle: CGFloat(distance / 20)) // 회전비 1:20
        self.loadingImg.transform = ts
        
        // 배경 뷰의 중심 좌표 설정
        self.bgCircle.center.y = distance / 2
    }
    
    // 스크롤 뷰의 드래그가 끝났을 때 호출되는 메서드
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 노란 원 다시 초기화
        self.bgCircle.frame.size.width = 0
        self.bgCircle.frame.size.height = 0
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
                self.empList = self.empDAO.find()
                self.tableView.reloadData()

                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "사원 목록 \n" + " 총 \(self.empList.count) 개"
            }
        })
        self.present(alert, animated: false)
    }
    
    @IBAction func editing(_ sender: Any) {
        if self.isEditing == false { // 편집 모드가 아닐 때
            self.setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else { // 편집 모드일 때
            self.setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
        }
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        // 새로고침 시 갱신되어야 할 내용들
        self.empList = self.empDAO.find()
        self.tableView.reloadData()
        
        // 당겨서 새로고침 기능 종료
        self.refreshControl?.endRefreshing()
        
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        UIView.animate(withDuration: 0.5) {
            self.bgCircle.frame.size.width = 80
            self.bgCircle.frame.size.height = 80
            self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
            self.bgCircle.center.y = distance / 2
            self.bgCircle.layer.cornerRadius = (self.bgCircle?.frame.size.width)! / 2
        }
    }
}
