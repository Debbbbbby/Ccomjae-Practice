//
//  CSStepper.swift
//  Chapter03-CSStepper
//
//  Created by Doyeon on 2023/02/03.
//

import UIKit

@IBDesignable
class CSStepper: UIView {
    
    // MARK: Properties
    public var leftBtn = UIButton(type: .system)
    public var rightBtn = UIButton(type: .system)
    public var centerLabel = UILabel() // 중앙 레이블
    public var value: Int = 0 { // 스테퍼의 현재값을 저장할 변수
        didSet {
            self.centerLabel.text = String(value)
        }
    }
    
    // 증감값 단위
    public var stepValue: Int = 1
    
    // 좌측 버튼의 타이틀 속성
    public var leftTitle: String = "⬇️" { // 스테퍼의 현재값을 저장할 변수
        didSet {
            self.leftBtn.setTitle(leftTitle, for: .normal)
        }
    }
    
    // 우측 버튼의 타이틀 속성
    public var rightTitle: String = "⬆️" { // 스테퍼의 현재값을 저장할 변수
        didSet {
            self.rightBtn.setTitle(rightTitle, for: .normal)
        }
    }
    
    // 센터 영역의 색상
    public var bgColor: UIColor = UIColor.cyan {
        didSet {
            self.centerLabel.backgroundColor = bgColor
        }
    }

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
    
    // MARK: Custom Method
    // 스테퍼 기본 속성 설정
    private func setUp() {
        
        let borderWidth: CGFloat = 0.5
        let borderColor = UIColor.blue.cgColor
        
        // 좌측 버튼 설정
        self.leftBtn.tag = -1
        self.leftBtn.setTitle(self.leftTitle, for: .normal)
        self.leftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.leftBtn.layer.borderWidth = borderWidth
        self.leftBtn.layer.borderColor = borderColor
        
        // 우측 버튼 설정
        self.rightBtn.tag = 1
        self.rightBtn.setTitle(self.rightTitle, for: .normal)
        self.rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.rightBtn.layer.borderWidth = borderWidth
        self.rightBtn.layer.borderColor = borderColor
        
        // 중앙 레이블 설정
        self.centerLabel.text = String(value)
        self.centerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.centerLabel.textAlignment = .center
        self.centerLabel.backgroundColor = self.bgColor
        self.centerLabel.layer.borderWidth = borderWidth
        self.centerLabel.layer.borderColor = borderColor
        
        // 영역별 객체를 서브 뷰로 추가
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        self.addSubview(self.centerLabel)
        
        // 버튼의 터치 이벤트와 valueChange(_:) 메서드 연결
        self.leftBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
    }
    
    // 뷰의 크기가 변경될 때 호출되는 메서드
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // 버튼의 너비 = 뷰 높이
        let btnWidth = self.frame.height
        
        // 레이블의 너비 = 뷰 전체 크기 - 양쪽 버튼의 너비 합
        let lblWidth = self.frame.width - (btnWidth * 2)

        self.leftBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        self.centerLabel.frame = CGRect(x: btnWidth, y: 0, width: lblWidth, height: btnWidth)
        self.rightBtn.frame = CGRect(x: btnWidth + lblWidth, y: 0, width: btnWidth, height: btnWidth)
    }
    
    // MARK: Action Method
    @objc public func valueChange(_ sender: UIButton) {
        // 현재의 value 값에 증감값 만큼 더하거나 빼기
        self.value += (sender.tag * self.stepValue)
    }

}
