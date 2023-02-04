//
//  RevealViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Doyeon on 2023/02/04.
//

import UIKit

class RevealViewController: UIViewController {
    
    // MARK: - Properties
    var contentVC: UIViewController?    // 콘텐츠를 담당한 뷰 컨트롤러
    var sideVC: UIViewController?       // 사이드 바 메뉴를 담당할 뷰 컨트롤러
    
    var isSideBarShowing = false        // 현재 사이드 바가 열려 있는지 여부
    
    let SLIDE_TIME = 0.3                // 사이드 바가 열리고 닫히는 데 걸리는 시간
    let SIDEBAR_WIDTH: CGFloat = 260    // 사이드 바가 열릴 너비
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // MARK: - Custom Functions
    /// 초기 화면 설정
    func setupView() {
        
        // _프론트 컨트롤러 객체를 읽어온다.
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_front") as? UINavigationController {
            
            // 읽어온 컨트롤러를 클래스 전체에서 참조할 수 있도록 contentVC 속성에 저장한다.
            self.contentVC = vc
            
            // _프론트 컨트롤러 객체를 메인 컨트롤러의 자식으로 등록한다.
            self.addChild(vc)
            self.view.addSubview(vc.view) // _프론트 컨트롤러의 뷰를 메인 컨트롤러의 서브 뷰로 등록
            
            // _프론트 컨트롤러에 부모 뷰 컨트롤러가 바뀌었음을 알려준다.
            vc.didMove(toParent: self)
        }
    }

}
