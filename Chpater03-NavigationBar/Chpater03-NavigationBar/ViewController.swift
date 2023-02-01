//
//  ViewController.swift
//  Chpater03-NavigationBar
//
//  Created by Doyeon on 2023/02/01.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 내비게이션 타이틀 초기화
        self.initTitle()
    }

    // 내비게이션 바 타이틀 구현
    func initTitle() {
        // 1. 내비게이션 타이틀용 레이블 객체
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        // 2. 속성 설정
        nTitle.numberOfLines = 2 // 두 줄까지 표시되도록 설정
        nTitle.textAlignment = .center
        nTitle.textColor = .white
        nTitle.font = UIFont.systemFont(ofSize: 18)
        nTitle.text = "58개 숙소 \n 1박(1월 10일 ~ 1월 11일)"
        
        // 3. 내비게이션 타이틀에 입력
        self.navigationItem.titleView = nTitle
        
        // 배경 색상 설정
        let color = UIColor(red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0)
        self.navigationController?.navigationBar.backgroundColor = color
    }
}
