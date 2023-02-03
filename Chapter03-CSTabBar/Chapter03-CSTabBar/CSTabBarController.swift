//
//  CSTabBarController.swift
//  Chapter03-CSTabBar
//
//  Created by Doyeon on 2023/02/03.
//

import UIKit

class CSTabBarController: UITabBarController {

    let csView = UIView()
    let tabItem01 = UIButton(type: .system)
    let tabItem02 = UIButton(type: .system)
    let tabItem03 = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 기존 탭 바 숨김처리
        self.tabBar.isHidden = true
        
        // 새로운 탭 바 역할을 할 뷰를 위해 기준 좌표와 크기 정의
        let width = self.view.frame.width
        let height: CGFloat = 50
        let x: CGFloat = 0
        let y = self.view.frame.height - height
        
        // 정의된 값을 이용하여 새로운 뷰의 속성 설정
        self.csView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(self.csView)
    }
}
