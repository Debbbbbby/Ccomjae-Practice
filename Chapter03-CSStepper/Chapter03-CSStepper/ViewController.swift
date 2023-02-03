//
//  ViewController.swift
//  Chapter03-CSStepper
//
//  Created by Doyeon on 2023/02/03.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CSSStepper 객체 정의
        let stepper = CSStepper()
        stepper.frame = CGRect(x: 30, y: 100, width: 130, height: 30)
        
        // ValueChange 이벤트가 발생하면 logging(_:) 메서드 호출
        stepper.addTarget(self, action: #selector(logging(_:)), for: .valueChanged)
        
        self.view.addSubview(stepper)
    }
    
    @objc func logging(_ sender: CSStepper) {
        print("현재 스테퍼의 값은 \(sender.value)입니다")
    }
}
