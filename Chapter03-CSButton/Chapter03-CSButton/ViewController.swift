//
//  ViewController.swift
//  Chapter03-CSButton
//
//  Created by Doyeon on 2023/02/03.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 30, y: 150, width: 150, height: 30)
        let csBtn = CSButton(frame: frame)
        csBtn.center.x = self.view.center.x
        self.view.addSubview(csBtn)
        
        let csBtn2 = CSButton()
        csBtn2.frame = CGRect(x: 30, y: 100, width: 150, height: 30)
        csBtn2.setTitle("CSButton2", for: .normal)
        csBtn2.center.x = self.view.center.x
        self.view.addSubview(csBtn2)
        
        // 인자값에 따라 다른 스타일로 결정되는 버튼 1
        let rectBtn = CSButton(type: .rect)
        rectBtn.frame = CGRect(x: 30, y: 200, width: 150, height: 30)
        self.view.addSubview(rectBtn)
        
        // 인자값에 따라 다른 스타일로 결정되는 버튼 2
        let circleBtn = CSButton(type: .circle)
        circleBtn.frame = CGRect(x: 200, y: 200, width: 200, height: 30)
        self.view.addSubview(circleBtn)
        
        // 인자값에 따라 다른 스타일로 결정되는 버튼 3
        let circleBtn2 = CSButton(type: .circle)
        circleBtn2.frame = CGRect(x: 80, y: 500, width: 200, height: 30)
        self.view.addSubview(circleBtn2)
        
        circleBtn2.style = .rect // circleBtn2이지만 프로퍼티 옵저버를 통해 다른 스타일로 쉽게 전환시킬 수 있음
    }
}

