//
//  CSButton.swift
//  Chapter03-CSButton
//
//  Created by Doyeon on 2023/02/03.
//

import UIKit

// 버튼 타입을 결정하는 열거형
public enum CSButtonType {
    case rect
    case circle
}

class CSButton: UIButton {
    
    // MARK: Property
    var style: CSButtonType = .rect {
        didSet { // 옵저버 didSet 블록 - 특정 프로퍼티의 값이 변할 때 마다 자동으로 호출
            // 값이 변경된 직후에 실행됨
            switch style {
            case .rect :
                self.backgroundColor = .black
                self.layer.borderColor = UIColor.black.cgColor
                self.layer.borderWidth = 2
                self.layer.cornerRadius = 0
                self.setTitleColor(.white, for: .normal)
                self.setTitle("Rect Button Type", for: .normal)
                
            case .circle :
                self.backgroundColor = .red
                self.layer.borderColor = UIColor.blue.cgColor
                self.layer.borderWidth = 2
                self.layer.cornerRadius = 20
                self.setTitle("Circle Button Type", for: .normal)
            }
        }
    }
    
    // MARK: init()
    /// required init 참고 : https://hururuek-chapchap.tistory.com/178
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        /// init(coder:)
        /// 스토리보드 방식으로 객체를 생성할 때 호출되는 초기화 메서드
        /// CSButton 클래스 타입의 버튼 객체를 사용하면 이 메서드가 실행된다.
        
        // 스토리보드 방식으로 버튼을 정의했을 때 적용된다.
        self.backgroundColor = .red
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("스토리보드 버튼", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// init(frame:)
        /// 프로그래밍 방식으로 버튼 객체를 사용할 때 필요한 메서드
        
        // 프로그래밍 방식으로 버튼을 정의했을 때 적용된다.
        self.backgroundColor = .gray
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("코드로 생성된 버튼", for: .normal)
    }
    
    // 인자값이 없는 초기화 메서드
    init() {
        super.init(frame: CGRect.zero)
    }
    
    // 버튼 타입을 결정하는 편의 초기화 메서드
    convenience init(type: CSButtonType) {
        self.init() // convenience 메서드는 본인의 지정 초기화 메서드를 호출해야함
        
        switch type {
        case .rect :
            self.backgroundColor = .black
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 2
            self.layer.cornerRadius = 0
            self.setTitleColor(.white, for: .normal)
            self.setTitle("Rect Button Type", for: .normal)
            
        case .circle :
            self.backgroundColor = .red
            self.layer.borderColor = UIColor.blue.cgColor
            self.layer.borderWidth = 2
            self.layer.cornerRadius = 20
            self.setTitle("Circle Button Type", for: .normal)
        }
        
        self.addTarget(self, action: #selector(counting(_:)), for: .touchUpInside)
    }
    
    // 버튼이 클릭된 횟수를 카운트하여 타이틀에 표시해 주는 함수
    @objc func counting(_ sender: UIButton) {
        sender.tag += 1
        sender.setTitle("\(sender.tag)번째 클릭", for: .normal)
    }
}
