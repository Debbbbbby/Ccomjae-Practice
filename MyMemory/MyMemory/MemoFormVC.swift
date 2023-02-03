//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by Doyeon on 2022/12/22.
//  메모 작성

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var subject: String!
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    
    override func viewDidLoad() {
        self.contents.delegate = self
        
        // 배경 이미지 설정
        let bgImage = UIImage(named: "memo-background")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        // 텍스트 뷰의 기본 속성
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        // 배경 이미지에 맞춰 줄 간격 설정
        let style = NSMutableParagraphStyle() // NSMutableParagraphStyle : 문단 스타일 설정 (Foundation Framework)
        style.lineSpacing = 9
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [.paragraphStyle : style])
        self.contents.text = ""
    }
    
    // 저장 버튼 클릭
    @IBAction func save(_ sender: Any) {
        // 1. 내용이 없을 경우 경고
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            return
        }
        
        // 2. MemoData 객체 생성하여 데이터 담기
        let data = MemoData()
        
        data.title = self.subject           // 제목
        data.contents = self.contents.text  // 내용
        data.image = self.preview.image     // 이미지
        data.regdate = Date()               // 작성 시각
        
        // 3. 앱 델리게이트 객체를 읽어와 memolist 배열에 MemoData 객체 추가
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memolist.append(data)
        
        // 4. 작성폼 화면 종료 및 이전 화면으로 돌아가기
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    // 카메라 버튼 클릭
    @IBAction func pick(_ sender: Any) {
        let picker = UIImagePickerController()      // 1. 인스턴스 생성
        
        picker.delegate = self                      // 2. 인스턴스의 델리게이트 속성을 현재 VC 인스턴스로 설정
        picker.allowsEditing = true                 // 3. 이미지 편집 허용
        
        self.present(picker, animated: false)       // 4. 이미지 피커 컨트롤러 화면 표시
    }
    
    // 이미지 선택시 자동 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.preview.image = info[.editedImage] as? UIImage // 선택된 이미지 출력
        picker.dismiss(animated: false)                     // 이미지 피커 컨트롤러 닫기
    }
    
    // 텍스트 뷰에 입력이 감지되면 자동 호출
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        let length = ( contents.length > 15 ? 15 : contents.length )
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        self.navigationItem.title = self.subject
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        
        let ts = TimeInterval(0.3)
        UIView.animate(withDuration: ts) {
            bar?.alpha = ( bar?.alpha == 0 ? 1 : 0 )
        }
    }
}
