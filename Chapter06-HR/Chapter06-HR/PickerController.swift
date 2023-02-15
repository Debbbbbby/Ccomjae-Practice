//
//  PickerController.swift
//  Chapter06-HR
//
//  Created by Doyeon on 2023/02/15.
//

import UIKit

class DepartPickerVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Properties
    let departDAO = DepartmentDAO()
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]!
    var pickerView: UIPickerView!

    var selectedDepartCd: Int {
        let row = self.pickerView.selectedRow(inComponent: 0)
        return self.departList[row].departCd
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.departList = self.departDAO.find()
        
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.view.addSubview(self.pickerView)
        
        // 외부에서 뷰 컨트롤러 참조할 때를 위한 사이즈 지정
        let pWidth = self.pickerView.frame.width
        let pHeight = self.pickerView.frame.height
        self.preferredContentSize = CGSize(width: pWidth, height: pHeight)
    }
    
    // MARK: - Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.departList.count
    }
    
    /// 피커 뷰의 각 행에 표시될 뷰를 결정하는 메서드
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleView = view as? UILabel ?? {
            let titleView = UILabel()
            titleView.font = UIFont.systemFont(ofSize: 18)
            titleView.textAlignment = .center
            titleView.text = "\(self.departList[row].departTitle) (\(self.departList[row].departAddr))"
            return titleView
        }()
        return titleView
    }
}
