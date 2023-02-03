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
    }
}

