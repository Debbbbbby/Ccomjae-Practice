//
//  CSLogButton.swift
//  MyMemory
//
//  Created by Doyeon on 2023/02/03.
//

import UIKit

public enum CSLogType: Int {
    case basic  // 기본 로그 타입
    case title  // 버튼의 타이틀 출력
    case tag    // 버튼의 태그값 출력
}

public class CSLogButton: UIButton {
    // 로그 출력 타입
    public var logType: CSLogType = .basic
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 버튼에 스타일 적용
        let bgImage = UIImage(named: "button-bg")
        self.setBackgroundImage(bgImage, for: .normal)
        self.setTitleColor(.white, for: .normal)
        
        // 버튼의 클릭 이벤트에 logging(_:) 메서드를 연결
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    
    // MARK: Action Method
    @objc func logging(_ sender: UIButton) {
        switch self.logType {
        case .basic:
            print("버튼이 클릭되었습니다.")
        case .title:
            let btnTitle = sender.titleLabel?.text ?? "타이틀 없는"
            print("\(btnTitle) 버튼이 클릭되었습니다.")
        case .tag:
            print("\(sender.tag) 버튼이 클릭되었습니다.")
        }
    }
}
