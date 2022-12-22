//
//  MemoListVC.swift
//  MyMemory
//
//  Created by Doyeon on 2022/12/22.
//  메모 목록

import UIKit

class MemoListVC: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 디바이스 스크린에 뷰 컨트롤러가 나타날 때마다 호출
    override func viewWillAppear(_ animated: Bool) {
        // 테이블 데이터를 다시 읽어들이기 -> 이에 따라 행을 구성하는 로직이 다시 실행됨
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    // 테이블 행 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.memolist.count
        return count
    }
    
    // 테이블 행 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1. memolist 배열 데이터엥서 주어진 행에 맞는 데이터를 꺼내기
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 2. 이미지 속성이 비어있을 경우 "memoCell" or "memoCellWithImage"
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
        // 3. 재사용 큐로부터 프로토타입 셀의 인스턴스 전달받기
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell // dequeueReusableCell로 받은 셀은 UITableViewCell 타입
        
        // 4. memoCell의 내용 구성하기
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        // 5. Date 타입의 날짜를 yyyy-MM-dd HH:mm:ss 포맷에 맞게 변경하기
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)
        
        // 6. cell 객체를 리턴
        return cell
    }
    
    // 테이블 특정 행 선택시 호출, 선택된 행의 정보는 indexPath에 담겨 전달됨
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. memolist 배열에서 선택된 행에 맞는 데이터 꺼내기
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 2. 상세 화면의 인스턴스 생성하기
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else { return }
        
        // 3. 값을 전달한 다음, 상세 화면으로 이동하기
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
