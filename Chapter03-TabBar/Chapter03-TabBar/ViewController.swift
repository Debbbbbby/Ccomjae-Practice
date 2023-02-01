//
//  ViewController.swift
//  Chapter03-TabBar
//
//  Created by Doyeon on 2023/02/01.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) title 레이블 생성
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        
        // 2) title 레이블 속성 설정
        title.text = "첫번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 18)
        
        // 3) 콘텐츠 내용에 맞게 레이블 크기 변경 -> 사용하지 않을 경우 엘립시스 발생
        title.sizeToFit()
        
        // 4) X축의 중앙에 오도록 설정
        /// [주의]
        /// 레이블 속성 설정한 후 사용해야 콘텐츠 길이가 길어져도 center에 정렬됨
        /// center 속성이 설정된 후에 객체의 크기가 변하면 한쪽으로 쏠리는 것 처럼 보일 수 있음
        title.center.x = self.view.frame.width / 2 // frame.width는 get-only 설정, 값을 대입하려면 frame.size.width 사용해야함
        
        // 5) 슈퍼 뷰에 추가
        self.view.addSubview(title)
        
        // 탭 바 아이템에 커스텀 이미지를 등록하고 탭 이름을 입력
        /// 다른 탭 바 아이템도 이렇게 설정할 경우 맨 처음 앱 실행시에는 ViewDidLoad되지 않기 때문에 깨진 이미지로 노출된다.
//        self.tabBarItem.image = UIImage(named: "calendar")
//        self.tabBarItem.title = "Calendar"
    }
}
