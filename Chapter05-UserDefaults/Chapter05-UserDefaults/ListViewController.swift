//
//  ListViewController.swift
//  Chapter05-UserDefaults
//
//  Created by Doyeon on 2023/02/07.
//

import UIKit

public enum GenderType: Int {
    case male = 0
    case female = 1
    
    func getGenderValue(value: Int) -> GenderType? {
        switch value {
        case 0:
            return .male
        case 1:
            return .female
        default:
            return nil
        }
    }
    
    func getGenderCode(value: GenderType) -> Int {
        return value.rawValue
    }
}

class ListViewController: UITableViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
    
    @IBAction func edit(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil,
                                      message: "이름을 입력하세요",
                                      preferredStyle: .alert)
        alert.addTextField() {
            $0.text = self.name.text
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            let value = alert.textFields?[0].text
            
            let plist = UserDefaults.standard
            plist.setValue(value, forKey: "name")
            plist.synchronize()
            
            self.name.text = value
        })
        self.present(alert, animated: false)
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        
        let value = sender.selectedSegmentIndex // 0: 남자, 1: 여자
        
        let plist = UserDefaults.standard // 기본 저장소 객체 불러오기
        plist.set(value, forKey: "gender") // "gender"라는 키로 값을 저장한다
        plist.synchronize() // 데이터 동기화
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        
        let value = sender.isOn // true: 기혼, false: 미혼
        
        let plist = UserDefaults.standard
        plist.set(value, forKey: "married")
        plist.synchronize()
    }
    
    /// 사용자가 테이블 뷰 셀을 선택했을 때 호출되는 메서드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 첫 번째 셀이 클릭되었을 때
        if indexPath.row == 0 {
            
            // 입력 가능한 알림창을 띄워 이름을 수정할 수 있도록 한다.
            let alert = UIAlertController(title: nil,
                                          message: "이름을 입력하세요.",
                                          preferredStyle: .alert)
            // 입력 필드 추가
            alert.addTextField() {
                $0.text = self.name.text // name 레이블의 텍스트를 입력폼에 기본값으로 넣어준다
            }
            
            // 버튼 및 액션 추가
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                // 사용자가 OK 버튼을 누르면 입력 필드에 입력된 값을 저장한다
                let value = alert.textFields?[0].text
                
                let plist = UserDefaults.standard
                plist.setValue(value, forKey: "name")
                plist.synchronize()
                
                self.name.text = value // 수정된 값을 이름 레이블에도 저장한다.
            })
            // 알림창을 띄운다
            self.present(alert, animated: false)
        }
        
    }
    
    override func viewDidLoad() {
        let plist = UserDefaults.standard
        
        // 저장된 값을 꺼내 각 컨트롤에 설정한다.
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
    }
    /* override 하지 않으면 자동으로 부모 메서드 호출됨
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView)
    }
     */
}
