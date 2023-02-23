//
//  Utils.swift
//  MyMemory
//
//  Created by Doyeon on 2023/02/09.
//

import UIKit

extension UIViewController {
    var tutorialSB: UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: Bundle.main)
    }
    
    func instanceTutorialVC(name: String) -> UIViewController? {
        return self.tutorialSB.instantiateViewController(withIdentifier: name)
    }
    
    func alert(_ message: String, completion: ( () -> Void )? = nil) {
        // 메인 스레드에서 실행되도록
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                completion?() // completion 매개변수의 값이 nil이 아닌 경우에만 실행되도록 설정
            }
            alert.addAction(okAction)
            self.present(alert, animated: false)
        }
    }
    
}
