//
//  ListViewController.swift
//  Chapter05-CustomPlist
//
//  Created by Doyeon on 2023/02/07.
//

import UIKit

class ListViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties
    @IBOutlet weak var account: UITextField!
    var accountlist = [String]()
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
        
        // 툴 바 객체 정의 - Done 버튼을 만들기 위한 일종의 컨테이너 객체
        let toolbar = UIToolbar()
        // 액세서리 뷰는 시스템에 의해 동적으로 좌표가 정해진다. 유일하게 height값만 조절 가능하다.
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        toolbar.barTintColor = .lightGray
        
        // 액세서리 뷰 영역에 툴 바 표시
        self.account.inputAccessoryView = toolbar
        
        // 툴 바에 들어갈 닫기 버튼
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone)
        
        // 가변 폭 버튼 정의
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        
        // 신규 계정 등록 버튼
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount)

        // 버튼을 툴 바에 추가
        toolbar.setItems([new, flexSpace, done], animated: true)
        
        // 기본 저장소 객체 불러오기
         let plist = UserDefaults.standard

         let accountlist = plist.array(forKey: "accountlist") as? [String] ?? [String]()
         self.accountlist = accountlist
        
        // 1.
        if let account = plist.string(forKey: "selectedAccount") {
            self.account.text = account
            let customPlist = "\(account).plist"
            
            // 2.
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // 2-1
            let path = paths[0] as NSString // 2-2
            let clist = path.strings(byAppendingPaths: [customPlist]).first! // 2-3
            
            // 3.
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
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
        
        // 기존 UserDefaults 저장 로직 시작
        // let plist = UserDefaults.standard // 기본 저장소 객체 불러오기
        // plist.set(value, forKey: "gender") // "gender"라는 키로 값을 저장한다
        // plist.synchronize() // 데이터 동기화
        
        // 새로운 plist 저장 로직 시작
        let customPlist = "\(self.account.text!).plist" // 읽어올 파일명
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
        
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn // true: 기혼, false: 미혼
        
        // 기존 UserDefaults 저장 로직 시작
        // let plist = UserDefaults.standard
        // plist.set(value, forKey: "married")
        // plist.synchronize()
        
        // 새로운 plist 저장 로직 시작
        let customPlist = "\(self.account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
        
        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)
        print("custom plist = \(plist)")
    }
    
    // MARK: - UIPickerViewDataSource Methods
    /// 생성할 컴포넌트의 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /// 지정된 컴포넌트가 가질 목록의 길이
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountlist.count
    }

    /// 지정된 컴포넌트의 목록 각 행에 출력될 내용을 정의
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountlist[row]
    }

    /// 지정된 컴포넌트의 목록 각 행을 사용자가 선택했을 때 실행할 액션을 정의
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 선택된 계정값을 텍스트 필드에 입력
        let account = self.accountlist[row]
        self.account.text = account
        
        // 사용자가 계정을 생성하면 이 계정을 선택한 것으로 간주하고 저장
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
    }
    
    // MARK: - UITableViewController Methods
    /// 사용자가 테이블 뷰 셀을 선택했을 때 호출되는 메서드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
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
                
                // 기존 UserDefaults 저장 로직 시작
                // let plist = UserDefaults.standard
                // plist.setValue(value, forKey: "name")
                // plist.synchronize()
                
                // 새로운 plist 저장 로직 시작
                let customPlist = "\(self.account.text!).plist" // 계정.plist : 불러올 파일명
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()

                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)

                self.name.text = value // 수정된 값을 이름 레이블에도 저장한다.
            })
            // 알림창을 띄운다
            self.present(alert, animated: false)
        }
    }
    
    // MARK: - Action Methods
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true)
        
        // 선택된 계정에 대한 커스텀 프로퍼티 파일을 읽어와 세팅한다.
        if let _account = self.account.text {
            let customPlist = "\(_account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
    }
    
    @objc func newAccount(_ sender: Any) {
        self.view.endEditing(true) // 일단 열려있는 입력용 뷰 부터 닫기
        
        let alert = UIAlertController(title: "새 계정을 입력하세요",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField() {
            $0.placeholder = "ex) abc@gmail.com"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            if let account = alert.textFields?[0].text {
                // 계정 목록 배열에 추가
                self.accountlist.append(account)
                // 계정 텍스트 필드에 표시
                self.account.text = account
                
                // 컨트롤 값을 모두 초기화
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                // 계정 목록을 통째로 저장
                let plist = UserDefaults.standard
                plist.set(self.accountlist, forKey: "accountlist")
                plist.set(account, forKey: "selectedAccount")
                plist.synchronize()
            }
        })
        self.present(alert, animated: false)
    }

}
