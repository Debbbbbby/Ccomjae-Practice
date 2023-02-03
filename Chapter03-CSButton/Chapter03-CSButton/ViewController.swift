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
        
        let circleBtn = CSButton(type: .circle)
        circleBtn.frame = CGRect(x: 200, y: 200, width: 200, height: 30)
        self.view.addSubview(circleBtn)
    }
}

