//
//  ListViewController.swift
//  Chapter05-CustomPlist
//
//  Created by Doyeon on 2023/02/07.
//

import UIKit

class ListViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Dummy
    let accountList = [
        "sqlpro@naver.com",
        "debby_@kakao.com",
        "asdf@gmail.com",
        "qwer@naver.com",
        "zxcv@kakao.com"
    ]
    
    // MARK: - Properties
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        let picker = UIPickerView()
        
        // 피커 뷰의 델리게이트 객체 지정
        picker.delegate = self
        
        // account 텍스트 필드 입력 방식을 가상 키보드 대신 피커 뷰로 설정
        self.account.inputView = picker
    }
    
    // MARK: - @IBAction Methods
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
    
    // MARK: - UIPickerViewDataSource Methods
    /// 생성할 컴포넌트의 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /// 지정된 컴포넌트가 가질 목록의 길이
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountList.count
    }

    /// 지정된 컴포넌트의 목록 각 행에 출력될 내용을 정의
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountList[row]
    }

    /// 지정된 컴포넌트의 목록 각 행을 사용자가 선택했을 때 실행할 액션을 정의
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 선택된 계정값을 텍스트 필드에 입력
        let account = self.accountList[row]
        self.account.text = account
        
        // 입력 뷰를 닫음
        self.view.endEditing(true)
    }
    
    // MARK: - UITableViewController Methods
    /// 사용자가 테이블 뷰 셀을 선택했을 때 호출되는 메서드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
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
    

}
