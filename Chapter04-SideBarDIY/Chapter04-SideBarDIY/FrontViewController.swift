//
//  FrontViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Doyeon on 2023/02/04.
//

import UIKit

class FrontViewController: UIViewController {
    
    // MARK: - Properties
    /// 사이드 바 오픈 기능을 위임할 델리게이트
    var delegate: RevealViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 사이드 바 오픈용 정의 버튼
        let btnSideBar = UIBarButtonItem(image: UIImage(named: "sidemenu"),
                                         style: UIBarButtonItem.Style.plain,
                                         target: self,
                                         action: #selector(moveSide(_:)) )
        
        // 버튼을 내비게이션 바의 왼쪽 영역에 추가
        self.navigationItem.leftBarButtonItem = btnSideBar
    }
    
    // MARK: - Action Method
    /// 사용자의 액션에 따라 델리게이트 메서드를 호출
    @objc func moveSide(_ sender: Any) {
        if self.delegate?.isSideBarShowing == false {
            self.delegate?.openSideBar(nil)
        } else {
            self.delegate?.closeSideBar(nil)
        }
    }

}
