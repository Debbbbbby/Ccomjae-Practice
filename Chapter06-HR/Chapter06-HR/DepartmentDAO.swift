//
//  DepartmentDAO.swift
//  Chapter06-HR
//
//  Created by Doyeon on 2023/02/14.
//

class DepartmentDAO {
    
    // 부서 정보를 담을 튜플 타입 정의
    typealias DepartRecord = (Int, String, String)
    
    // SQLite 연결 및 초기화
    lazy var fmdb: FMDatabase! = {
        // 1. 파일 매니저 객체 생성
        let fileMgr = FileManager.default
        
        // 2. 샌드박스 내 문서 디렉토리에서 DB파일 경로 확인
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        // 3. 샌드박스 경로에 파일이 없다면 메인 번들에 만들어 둔 hr.sqlite를 가져와 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        // 4. 준비된 DB 파일을 바탕으로 FMDatabase 객체 생성
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open() // DepartmentDAO 객체 생성시 DB 연결
    }
    
    deinit {
        self.fmdb.close() // DepartmentDAO 객체 해제시 DB 해제
    }
    
    /// 부서 전체 정보 불러오기
    func findAll() -> [DepartRecord] {
        var departList = [DepartRecord]()
        
        do {
            let sql = """
                SELECT depart_cd, depart_title, depart_addr
                  FROM department
                 ORDER BY depart_cd
            """
            
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                let departCd    = rs.int(forColumn: "depart_cd")
                let departTitle = rs.string(forColumn: "depart_title")
                let departAddr  = rs.string(forColumn: "depart_addr")
                
                departList.append( (Int(departCd), departTitle!, departAddr! ) )
            }
        } catch let error as NSError {
            print("failed : \(error.localizedDescription)")
        }
        return departList
    }
    
    /// 단일 부서 정보 불러오기
    func getOne(departCd: Int) -> DepartRecord? {
        let sql = """
            SELECT depart_cd, depart_title, depart_addr
              FROM department
             WHERE depart_cd = ?
        """
        
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [departCd])
        
        if let _rs = rs {
            _rs.next()
            
            let departId    = _rs.int(forColumn: "depart_cd")
            let departTitle = _rs.string(forColumn: "depart_title")
            let departAddr  = _rs.string(forColumn: "depart_addr")
            
            return (Int(departId), departTitle!, departAddr!)
        } else {
            return nil
        }
    }
    
}
