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
    }
}
