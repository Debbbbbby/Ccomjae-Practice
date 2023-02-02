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
        self.initTitleImage()
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
        let color = UIColor(red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0) // 안됨
        self.navigationController?.navigationBar.backgroundColor = color
    }
    
    // 타이틀에 이미지를 표시하는 메소드
    func initTitleImage() {
        let image = UIImage(named: "swift_logo")
        let imageV = UIImageView(image: image)
        
        self.navigationItem.titleView = imageV
        self.navigationController?.navigationBar.backgroundColor = .gray
    }

}
