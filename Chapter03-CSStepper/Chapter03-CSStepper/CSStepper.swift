//
//  CSStepper.swift
//  Chapter03-CSStepper
//
//  Created by Doyeon on 2023/02/03.
//

import UIKit

class CSStepper: UIView {
    
    public var leftBtn = UIButton(type: .system)
    public var rightBtn = UIButton(type: .system)
    public var centerLabel = UILabel() // 중앙 레이블
    public var value: Int = 0 // 스테퍼의 현재값을 저장할 변수

    // 스토리보드에서 호출할 초기화 메서드
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    // 프로그래밍 방식으로 호출할 초기화 메서드
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    // 스테퍼 기본 속성 설정
    private func setUp() {
        
        let borderWidth: CGFloat = 0.5
        let borderColor = UIColor.blue.cgColor
        
        // 좌측 버튼 설정
        self.leftBtn.tag -= 1
        self.leftBtn.setTitle("⬇️", for: .normal)
        self.leftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.leftBtn.layer.borderWidth = borderWidth
        self.leftBtn.layer.borderColor = borderColor
        
        // 우측 버튼 설정
        self.rightBtn.tag += 1
        self.rightBtn.setTitle("⬆️", for: .normal)
        self.rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.rightBtn.layer.borderWidth = borderWidth
        self.rightBtn.layer.borderColor = borderColor
        
        // 중앙 레이블 설정
        self.centerLabel.text = String(value)
        self.centerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.centerLabel.textAlignment = .center
        self.centerLabel.backgroundColor = .cyan
        self.centerLabel.layer.borderWidth = borderWidth
        self.centerLabel.layer.borderColor = borderColor
        
        // 영역별 객체를 서브 뷰로 추가
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        self.addSubview(self.centerLabel)
    }

}
