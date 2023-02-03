//
//  CSButton.swift
//  Chapter03-CSButton
//
//  Created by Doyeon on 2023/02/03.
//

import UIKit

class CSButton: UIButton {
    
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

}
