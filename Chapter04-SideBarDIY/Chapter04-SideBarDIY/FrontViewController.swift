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
        
        // 화면 끝에서 다른 쪽으로 패닝하는 제스처를 정의
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(moveSide))
        dragLeft.edges = UIRectEdge.left // 시작 모서리는 왼쪽
        self.view.addGestureRecognizer(dragLeft) // 뷰에 제스처 객체를 등록
        
        // 화면을 스와이프하는 제스처 정의(사이드 메뉴 닫기)
        let dragRight = UISwipeGestureRecognizer(target: self, action: #selector(moveSide))
        dragRight.direction = .left
        self.view.addGestureRecognizer(dragRight)
    }
    
    // MARK: - Action Method
    /// 사용자의 액션에 따라 델리게이트 메서드를 호출
    @objc func moveSide(_ sender: Any) {
        
        if sender is UIScreenEdgePanGestureRecognizer {
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.delegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem {
            if self.delegate?.isSideBarShowing == false {
                self.delegate?.openSideBar(nil)
            } else {
                self.delegate?.closeSideBar(nil)
            }
        }
    }
}
