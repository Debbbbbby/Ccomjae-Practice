//
//  ListVC.swift
//  Chapter07-CoreData
//
//  Created by Doyeon on 2023/02/22.
//

import UIKit
import CoreData

class ListVC: UITableViewController {
    
    // MARK: - Properties
    // 데이터 소스 역할을 할 배열 변수
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()

    // MARK: - Life Cycle
    // 화면 및 로직 초기화 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addBtn
    }

    // MARK: - Methods
    // 데이터을 읽어올 메서드
    func fetch() -> [NSManagedObject] {
        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // WHERE
        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext // WHAT
        // 3. 요청 객체 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board") // HOW, 유사 SELECT
        
        // 3-1. 정렬 속성 설정
        let sort = NSSortDescriptor(key: "regdate", ascending: false) // false : 내림차순, 최신글이 위로
        fetchRequest.sortDescriptors = [sort]
        
        // 4. 데이터 가져오기
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
    // 데이터를 저장할 메서드
    func save(title: String, contents: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        // Log 관리 객체 생성 및 어트리뷰트에 값 대입
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.create.rawValue
        
        // 게시글 객체의 logs 속성에 새로 생성된 로그 객체 추가
        (object as! BoardMO).addToLogs(logObject)
        
        do {
            try context.save()
            self.list.insert(object, at: 0)
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    // 데이터 저장 버튼에 대한 액션 메서드
    @objc func add(_ sender: Any) {
        let alert = UIAlertController(title: "게시글 등록", message: nil, preferredStyle: .alert)
        alert.addTextField() { $0.placeholder = "제목" }
        alert.addTextField() { $0.placeholder = "내용" }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text,
                  let contents = alert.textFields?.last?.text else {
                return
            }
            if self.save(title: title, contents: contents) == true {
                self.tableView.reloadData()
            }
        })
        self.present(alert, animated: false)
    }
    
    func delete(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // 컨텍스트로부터 해당 객체 삭제
        context.delete(object)
        
        // 영구 저장소에 커밋
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    func edit(object: NSManagedObject, title: String, contents: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.edit.rawValue
        (object as! BoardMO).addToLogs(logObject)
        
        do {
            try context.save()
            self.list = self.fetch()
            return true
        } catch {
            context.rollback()
            return false
        }
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 해당하는 데이터 가져오기
        let record = self.list[indexPath.row]
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "contents") as? String
        
        // 셀 생성 및 대입
        let cell = tv.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = contents
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        
        if self.delete(object: object) {
            // 코어 데이터에서 삭제되고 나면 배열 목록과 테이블 뷰의 행도 삭제한다.
            self.list.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        let title = object.value(forKey: "title") as? String
        let contents = object.value(forKey: "contents") as? String
        
        let alert = UIAlertController(title: "게시글 수정", message: nil, preferredStyle: .alert)
        alert.addTextField() { $0.text = title }
        alert.addTextField() { $0.text = contents }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text,
                  let contents = alert.textFields?.last?.text else {
                return
            }
            if self.edit(object: object, title: title, contents: contents) == true {
                //self.tableView.reloadData()
                
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = title
                cell?.detailTextLabel?.text = contents
                
                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.tableView.moveRow(at: indexPath, to: firstIndexPath) // 셀 위치 변경
            }
        })
        self.present(alert, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        let uvc = self.storyboard?.instantiateViewController(withIdentifier: "LogVC") as! LogVC
        uvc.board = (object as! BoardMO)
        self.show(uvc, sender: self)
    }
    
}
