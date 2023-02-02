//
//  ViewController.swift
//  Chapter03-NavigationBar
//
//  Created by Doyeon on 2023/02/02.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내비게이션 타이틀 초기화
        self.initTitleInput()
    }
    
    // 내비게이션 바 타이틀 구현
    func initTitle() {
        // 1. 내비게이션 타이틀용 레이블 객체
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        // 2. 속성 설정
        nTitle.numberOfLines = 2 // 두 줄까지 표시되도록 설정
        nTitle.textAlignment = .center
        nTitle.textColor = .white
        nTitle.font = UIFont.systemFont(ofSize: 18)
        nTitle.text = "58개 숙소 \n 1박(1월 10일 ~ 1월 11일)"
        
        // 3. 내비게이션 타이틀에 입력
        self.navigationItem.titleView = nTitle
        
        // 배경 색상 설정
        let color = UIColor(red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0)
        self.navigationController?.navigationBar.backgroundColor = color
    }
    
    func initTitleNew() {
        // 1. 복합적인 레이아웃을 구현할 컨테이너 뷰
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        
        // 2. 상단 레이블 정의
        let topTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.font = UIFont.systemFont(ofSize: 18)
        topTitle.textColor = .white
        topTitle.text = "58개 숙소"
        
        // 3. 하단 레이블 정의
        let subTitle = UILabel(frame: CGRect(x: 0, y: 20, width: 200, height: 18))
        subTitle.numberOfLines = 1
        subTitle.textAlignment = .center
        subTitle.font = UIFont.systemFont(ofSize: 14)
        subTitle.textColor = .white
        subTitle.text = "1박(1월 10일 ~ 1월 11일)"
        
        // 4. 상하단 레이블을 컨테이너 뷰에 추가한다.
        containerView.addSubview(topTitle)
        containerView.addSubview(subTitle)
        
        // 5. 내비게이션 타이틀에 컨테이너 뷰를 대입한다.
        self.navigationItem.titleView = containerView
        
        // 배경 색상 설정
        let color = UIColor(red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0)
        self.navigationController?.navigationBar.backgroundColor = color
    }
    
    // 타이틀에 이미지를 표시하는 메소드
    func initTitleImage() {
        let image = UIImage(named: "swift_logo")
        let imageV = UIImageView(image: image)
        
        self.navigationItem.titleView = imageV
        self.navigationController?.navigationBar.backgroundColor = .gray
    }
    
    // 텍스트 필드를 이용하여 타이틀을 구성하는 메소드
    func initTitleInput() {
        // 텍스트 필드 객체 생성
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.autocapitalizationType = .none // 자동 대문자 변환 속성 사용하지 않음
        tf.autocorrectionType = .no // 자동 입력 기능 해제
        tf.spellCheckingType = .no // 스펠링 체크 기능 해제
        tf.keyboardType = .URL // URL 입력 전용 키보드
        tf.keyboardAppearance = .dark // 다크모드 키보드로 보이기
        tf.layer.borderWidth = 0.3
        tf.layer.cornerRadius = 6
        tf.layer.borderColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0).cgColor
        
        // 타이틀 뷰 속성에 대입
        self.navigationItem.titleView = tf
        let bgColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        self.navigationController?.navigationBar.backgroundColor = bgColor
        
        // 왼쪽 아이템 영역에 들어갈 뷰
        let back = UIImage(named: "arrow-back")
        let leftItem = UIBarButtonItem(image: back, style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = leftItem
        
        // 1) 오른쪽 영역에 들어갈 컨테이너 뷰
        let rv = UIView()
        rv.frame = CGRect(x: 0, y: 0, width: 70, height: 37)
        
        let rightItem = UIBarButtonItem(customView: rv)
        self.navigationItem.rightBarButtonItem = rightItem
        
        // 2) 카운트 값을 표시할 레이블 구성
        let cnt = UILabel()
        cnt.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        cnt.font = UIFont.boldSystemFont(ofSize: 10)
        cnt.textColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
        cnt.text = "12"
        cnt.textAlignment = .center
        
        // 외곽선
        cnt.layer.cornerRadius = 3
        cnt.layer.borderWidth = 2
        cnt.layer.borderColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0).cgColor
        
        rv.addSubview(cnt)
        
        // 3) more 버튼 구현
        let more = UIButton(type: .system)
        more.frame = CGRect(x: 50, y: 10, width: 16, height: 16)
        more.setImage(UIImage(named: "more"), for: .normal)
        
        rv.addSubview(more)
    }

}
