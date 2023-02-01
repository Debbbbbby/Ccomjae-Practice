//
//  ThirdViewController.swift
//  Chapter03-TabBar
//
//  Created by Doyeon on 2023/02/01.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        title.text = "세번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.sizeToFit()
        title.center.x = self.view.frame.width / 2
        self.view.addSubview(title)
    }
}
