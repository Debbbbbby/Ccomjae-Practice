//
//  EmployeeDAO.swift
//  Chapter06-HR
//
//  Created by Debby on 2022/09/22.
//

// MARK: - STRUCT
struct EmployeeVO {
    var empCd = 0                   // 사원 코드
    var empName = ""                // 사원명
    var joinDate = ""               // 입사일
    var stateCd = EmpStateType.ING  // 재직 상태(기본값 : 재직중)
    var departCd = 0                // 소속 부서 코드
    var departTitle = ""            // 소속 부서명
}
/**
 왜 class가 아니라 struct 로 VO 객체를 만들었나?
 객체의 생성 및 초기화 과정이 훨씬 가볍고 빠르기 때문에 VO 패턴의 객체는 구조체로 정의하는 것이 좋다.
 예외 1) VO 객체를 여러곳에 전달해야할 때
 - 참조 타입인 class 에 비해 값을 전부 전달해야하기 때문에 여러곳에 전달하면 무거워 질 수 있다.
 예외 2) 객체 내부에 클래스 기반의 멤버 변수가 사용될 때
 - 클래스 기반 멤버 변수의 레퍼런스까지 함께 복사 될 수 있고, 이로 인해 변경되면 안되는 값이 변경될 수 있기 때문이다.
 예외 3) 상속 구조가 필요할 때
 - 구조체는 상속 불가능하다.
 */

// MARK: - CLASS
class EmployeeDAO {
    // FMDatabase 객체 생성 및 초기화
    lazy var fmdb: FMDatabase! = {
        // 1. 파일 매니저 객체 생성
        let fileMgr = FileManager.default
        
        // 2. 샌드박스 내 문서 디렉터리 경로에서 데이터베이스 파일을 읽어오기
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        // 3. 샌드박스 경로에 hr.sqlite 파일이 없다면 메인 번들에 만들어 둔 파일을 가져와 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        // 4. 준비된 데이터베이스 파일을 바탕으로 FMDatabase 객체 생성
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open()
    }
    deinit {
        self.fmdb.close()
    }
    
    // MARK: - Custom Methods
    func find() -> [EmployeeVO] {
        // 반환할 데이터를 담을 타입의 객체 정의
        var employeeList = [EmployeeVO]()
        
        do {
            let sql = """
                SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
                FROM employee
                JOIN department On department.depart_cd = employee.depart_cd
                ORDER BY employeee.depart_cd ASC
            """
                
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                var record = EmployeeVO()
                
                record.empCd = Int(rs.int(forColumn: "emp_cd"))
                record.empName = rs.string(forColumn: "emp_name")!
                record.joinDate = rs.string(forColumn: "join_date")!
                record.departTitle = rs.string(forColumn: "depart_title")!
                
                let cd = Int(rs.int(forColumn: "state_cd")) // DB값
                record.stateCd = EmpStateType(rawValue: cd)!
                
                employeeList.append(record)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return employeeList
    }
    
    func create(param: EmployeeVO) -> Bool {
        do {
            let sql = """
                INSERT INTO employee (emp_name, join_date, state_cd, depart_cd)
                VALUES ( ? , ? , ? , ? )
            """
            
            // Prepared Statement를 위한 인자값
            var params = [Any]()
            params.append(param.empName)
            params.append(param.joinDate)
            params.append(param.stateCd.rawValue)
            params.append(param.departCd)
            
            try self.fmdb.executeUpdate(sql, values: params)
            
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }
    
    func remove(empCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM employee WHERE emp_cd = ? "
            try self.fmdb.executeUpdate(sql, values: [empCd])
            return true
        } catch let error as NSError {
            print("Delete Error : \(error.localizedDescription)")
            return false
        }
    }

}

// MARK: - 재직상태
enum EmpStateType: Int {
    case ING = 0, STOP, OUT // 순서대로 재직중(0), 휴직(1), 퇴사(2)
    
    // 재직 상태를 문자열로 변환해 주는 메소드
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
/**
 일반적으로 열거형 타입을 정의하여 사용하는 것이 훨씬 효율적인 경우 2가지
 1. 가질 수 있는 값의 범위가 한정될 때
 2. 그 값이 단순한 숫자나 문자가 아니라 특정 의미를 띠는 코드 형식일 때
 
 EmpStateType.ING으로 swift 아키텍처 내에서 통용되는 타입과 값을 지정하나 DB에 이대로 저장하지는 않는다.
 DB는 state_cd 값을 Integer 타입으로 저장해야하기 때문에 0, 1, 2로 구분하여 저장하되 프로그램에서 해석을 그 번호에 맞게 처리한다.
 열거형의 특성상 첫 번째 항목만 정수값을 지정하면 나머지 값은 순서대로 알아서 지정된다.
 let stateCd = EmpStateType.ING 라면 stateCd.rawValue 는 0 이 된다.
 */

