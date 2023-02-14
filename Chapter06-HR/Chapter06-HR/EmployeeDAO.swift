//
//  EmployeeDAO.swift
//  Chapter06-HR
//
//  Created by Doyeon on 2023/02/14.
//

enum EmpStateType: Int {
    case ING = 0, STOP, OUT
    
    /// 재직 상태를 문자열로 변환
    func desc() -> String {
        switch self {
        case .ING:
            return "재직중"
        case .STOP:
            return "휴직"
        case .OUT:
            return "퇴사"
        }
    }
}

class EmployeeDAO {
    
}
