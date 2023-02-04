//
//  SideBarViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Doyeon on 2023/02/04.
//

import UIKit

class SideBarViewController: UITableViewController {
    // MARK: - Properties
    /// 메뉴 제목 배열
    let titles = [
        "메뉴 01",
        "메뉴 02",
        "메뉴 03",
        "메뉴 04",
        "메뉴 05"
    ]
    
    let icons = [
        UIImage(named: "icon01"),
        UIImage(named: "icon02"),
        UIImage(named: "icon03"),
        UIImage(named: "icon04"),
        UIImage(named: "icon05")
    ]
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 행의 개수 반환
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    /// 각 행에 맞는 셀 객체 반환
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. 재사용 큐에 테이블 셀을 꺼내온다.
        /// 재사용 큐에 등록할 식별자
        let id = "menucell"

        // 2. 재사용 큐에 menucell키로 등록된 테이블 뷰 셀이 없다면 새로 추가한다.
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)

        // 3. 타이틀과 이미지를 대입한다.
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]

        // 4. 폰트 설정
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)

        /*
        // [나타내야 할 메뉴가 적다면 굳이 재사용 큐를 사용하지 않아도 됨]
        let cell = UITableViewCell()
        
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        */
        
        return cell
    }

}
