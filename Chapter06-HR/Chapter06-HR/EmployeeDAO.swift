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

struct EmployeeVO {
    var empCd = 0 // 사원코드
    var empName = "" // 사원명
    var joinDate = "" // 입사일
    var stateCd = EmpStateType.ING // 재직 상태 (기본값 : 재직중)
    var departCd = 0 // 부서 코드
    var departTitle = "" // 소속 부서명
}

class EmployeeDAO {
    
}
