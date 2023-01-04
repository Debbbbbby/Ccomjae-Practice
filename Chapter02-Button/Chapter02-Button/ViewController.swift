//
//  ViewController.swift
//  Chapter02-Button
//
//  Created by Doyeon on 2023/01/04.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 객체 생성, 속성 설정
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 50, y: 100, width: 150, height: 30)
        btn.setTitle("테스트", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        
        // 버튼 수평 중앙 정렬
        let centerX = self.view.frame.size.width / 2
        btn.center = CGPoint(x: centerX, y: 100)
        
        self.view.addSubview(btn)
        
        // 버튼의 이벤트와 메소드를 연결
        btn.addTarget(self, action: #selector(btnOnClickAny), for: .touchUpInside)
    }
    
    @objc func btnOnClickAny(_ sender: Any) {
        // 호출한 객체가 버튼이라면
        if let btn = sender as? UIButton {
            btn.setTitle("클릭됨", for: .normal)
        }
    }
    
    @objc func btnOnClickButton(_ sender: UIButton) {
        // UIButton으로 한정하면 버튼만 입력받을 수 있으니 주의!
        sender.setTitle("클릭됨", for: .normal)
    }
}

