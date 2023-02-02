//
//  ListViewController.swift
//  Chapter03-Alert
//
//  Created by Doyeon on 2023/02/02.
//

import UIKit

class ListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize.height = 220
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "\(indexPath.row) 번째 옵션입니다."
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        return cell
    }
    
}
