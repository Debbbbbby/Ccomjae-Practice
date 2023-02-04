//
//  FrontViewController.swift
//  Chapter04-SideBar
//
//  Created by Doyeon on 2023/02/04.
//

import UIKit

class FrontViewController: UIViewController {
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
    }
    
    func sideMenu() {
        if let revealVC = self.revealViewController() {
            self.sideBarButton.target = revealVC
            self.sideBarButton.action = #selector(revealVC.revealToggle(_:))
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }
}
