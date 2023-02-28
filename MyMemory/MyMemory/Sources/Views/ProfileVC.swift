//
//  ProfileVC.swift
//  MyMemory
//
//  Created by Doyeon on 2023/02/06.
//

import UIKit
import Alamofire
import LocalAuthentication

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let profileImage = UIImageView()
    let tv = UITableView()
    let uinfo = UserInfoManager() // 개인 정보 관리 매니저
    
    // API 호출 상태값을 관리할 변수
    var isCalling = false
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.navigationItem.title = "프로필"
        
        // 뒤로 가기 버튼 처리
        let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // 배경 이미지 설정
        let bg = UIImage(named: "profile-bg")
        let bgImg = UIImageView(image: bg)
        
        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
        bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
        bgImg.layer.borderWidth = 0
        bgImg.layer.masksToBounds = true
        
        self.view.addSubview(bgImg)
        
        self.view.bringSubviewToFront(self.tv)
        self.view.bringSubviewToFront(self.profileImage)
        
        // 프로필 사진에 들어갈 이미지
        let image = self.uinfo.profile
        
        // 프로필 이미지 처리
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 270)
        
        // 프로필 이미지 둥글게 만들기
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        
        // 루트 뷰에 추가
        self.view.addSubview(self.profileImage)
        
        // 테이블 뷰
        self.tv.frame = CGRect(x: 0,
                               y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20,
                               width: self.view.frame.width,
                               height: 100)
        self.tv.dataSource = self
        self.tv.delegate = self
        
        self.view.addSubview(self.tv)
        
        // 내비게이션 바 숨김 처리
        self.navigationController?.navigationBar.isHidden = true
        
        self.drawBtn()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profile))
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.isUserInteractionEnabled = true
        
        // 인디케이터 뷰를 화면 맨 앞으로
        self.view.bringSubviewToFront(self.indicatorView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 토큰 인증 여부 체크
        self.tokenValidate()
    }
    
    // MARK: - UITableViewDataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = self.uinfo.name ?? "Login Please"
        case 1:
            cell.textLabel?.text = "계정"
            cell.detailTextLabel?.text = self.uinfo.account ?? "Login Please"
        default:
            ()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.uinfo.isLogin == false {
            // 로그인되어 있지 않다면 로그인 창을 띄워 준다.
            self.doLogin(self.tv)
        }
    }
    
    // MARK: - Action Mehtods
    @objc func close(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func doLogin(_ sender: Any) {
        
        if self.isCalling == true {
            self.alert("응답을 기다리는 중입니다.\n잠시만 기다려 주세요.")
            return
        } else {
            self.isCalling = true
        }
        
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        // 알림창에 들어갈 입력폼 추가
        loginAlert.addTextField() {
            $0.placeholder = "Your Account"
        }
        loginAlert.addTextField() {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
        }
        
        // 알림창 버튼 추가
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.isCalling = false
        })
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive) { (_) in
            // 인디케이터 실행
            self.indicatorView.startAnimating()
            
            let account = loginAlert.textFields?[0].text ?? "" // 계정 필드
            let passwd = loginAlert.textFields?[1].text ?? "" // 비밀번호 필드
            
            self.uinfo.login(account: account, passwd: passwd, success: {
                // 인디케이터 종료
                self.indicatorView.stopAnimating()
                self.isCalling = false
                
                self.tv.reloadData() // 테이블 뷰 갱신
                self.profileImage.image = self.uinfo.profile // 이미지 프로필 갱신
                self.drawBtn() // 로그인 상태에 따라 적절한 버튼을 출력
                
                // 서버와 데이터 동기화
                let sync = DataSync()
                
                DispatchQueue.global(qos: .background).async {
                    sync.downloadBackupData() // 서버에 저장된 데이터가 있으면 내려받는다.
                }
                
                DispatchQueue.global(qos: .background).async {
                    sync.uploadData() // 서버에 저장해야 할 데이터가 있으면 업로드한다.
                }
            }, fail: { msg in
                // 인디케이터 종료
                self.indicatorView.stopAnimating()
                self.isCalling = false
                
                self.alert(msg)
            })
        })
        self.present(loginAlert, animated: false)
    }
    
    @objc func doLogout(_ sender: Any) {
        let msg = "로그아웃 하시겠습니까?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { (_) in
            self.indicatorView.startAnimating()
            
            self.uinfo.logout() {
                self.indicatorView.stopAnimating()
                
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn() // 로그인 상태에 따라 적절한 버튼을 출력
            }
        })
        self.present(alert, animated: false)
    }
    
    /// 프로필 사진의 소스 타입을 선택하는 액션 메서드
    @objc func profile(_ sender: UIButton) {
        // 로그인되어 있지 않을 경우, 프로필 이미지 등록을 막고 대신 로그인 창을 띄운다.
        guard self.uinfo.account != nil else {
            self.doLogin(self)
            return
        }
        
        let msg = "사진을 가져올 곳을 선택해 주세요."
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .actionSheet)
        
        // 카메라를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
                self.imgPicker(.camera)
            })
        }
        
        // 저장된 앨범을 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { _ in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        
        // 포토 라이브러리를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default) { _ in
                self.imgPicker(.photoLibrary)
            })
        }
        
        // 취소 버튼 추가
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        // 액션 시트 참 실행
        self.present(alert, animated: true)
    }
    
    // MARK: - Custom Methods
    func drawBtn() {
        // 버튼을 감쌀 뷰를 정의한다.
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        
        self.view.addSubview(v)
        
        // 버튼을 정의한다.
        let btn = UIButton(type: .system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2
        btn.center.y = v.frame.size.height / 2
        
        // 로그인 상태일 때는 로그아웃 버튼, 로그아웃 상태에서는 로그인 버튼을 만들어 준다.
        if self.uinfo.isLogin == true {
            btn.setTitle("로그아웃", for: .normal)
            btn.addTarget(self, action: #selector(doLogout), for: .touchUpInside)
        } else {
            btn.setTitle("로그인", for: .normal)
            btn.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
        }
        v.addSubview(btn)
    }
    
    func imgPicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.indicatorView.startAnimating()
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uinfo.newProfile(img, success: {
                self.indicatorView.stopAnimating()
                self.profileImage.image = img
            }, fail: {msg in
                self.indicatorView.stopAnimating()
                self.alert(msg)
            })
        }
        // 이 구문을 누락하면 이미지 피커 컨트롤러 창이 닫히지 않는다.
        picker.dismiss(animated: true)
    }
    
    @IBAction func backProfileVC(_ segue: UIStoryboardSegue) {
        // 단지 프로필 화면으로 되돌아오기 위한 표식 역할만 할 뿐이므로 아무 내용도 작성하지 않음
        // 스토리보드에서 신규 계정 등록 후 프로필 화면으로 돌아오기 위해
        // 신규 계정 생성 뷰에서 Exit Code -> backProfileVC 로 연결
    }
    
}

extension ProfileVC {
    // 토큰 인증 메서드 : 토큰 유효성 검증
    func tokenValidate() {
        // 0. 응답 캐시를 사용하지 않도록 삭제 처리
        URLCache.shared.removeAllCachedResponses()
        
        // 1. 키 체인에 액세스 토큰이 없을 경우 유효성 검증을 진행하지 않음
        let tk = TokenUtils()
        guard let header = tk.getAuthoriazationHeader() else {
            return
        }
        
        self.indicatorView.startAnimating()
        
        // 2. tokenValidate API 호출
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/tokenValidate"
        let validate = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        
        validate.responseJSON { res in
            self.indicatorView.stopAnimating()
            
            let responseBody = try! res.result.get()
            print(responseBody)
            guard let jsonObject = responseBody as? NSDictionary else {
                self.alert("잘못된 응답입니다.")
                return
            }
            
            // 3. 응답 결과 처리
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode != 0 { // 3-1. 응답 결과가 실패일 때, 즉 토큰이 만료되었을 때
                self.touchID() // 로컬 인증 실행
            }
        } // end of response closure
    } // end of func tokenValidate()
    
    // 터치 아이디 인증 메서드
    func touchID() {
        // 1. LAContext 인스턴스 생성
        let context = LAContext()
        
        // 2. 로컬 인증에 사용할 변수 정의
        var error: NSError?
        let msg = "인증이 필요합니다."
        let deviceAuth = LAPolicy.deviceOwnerAuthenticationWithBiometrics // 인증 정책
        
        // 3. 로컬 인증이 사용 가능한지 여부 확인
        if context.canEvaluatePolicy(deviceAuth, error: &error) {
            // 4. 터치 아이디 인증창 실행
            context.evaluatePolicy(deviceAuth, localizedReason: msg) { (success, e) in
                if success { // 5. 인증 성공 : 토큰 갱신 로직
                    self.refresh()
                } else { // 6. 인증 실패
                    // 인증 실패 원인에 대한 대응 로직
                    print((e?.localizedDescription)!)
                    
                    switch (e!._code) {
                    case LAError.systemCancel.rawValue:
                        self.alert("시스템에 의해 인증이 취소되었습니다.")
                    case LAError.userCancel.rawValue:
                        self.alert("사용자에 의해 인증이 취소되었습니다.")
                    case LAError.userFallback.rawValue:
                        OperationQueue.main.addOperation() {
                            self.commonLogout(true)
                        }
                    default:
                        OperationQueue.main.addOperation() {
                            self.commonLogout(true)
                        }
                    }
                }
            }
        } else { // 7. 인증창이 실행되지 못한 경우
            // 인증창 실행 불가 원인에 대한 대응 로직
            print(error!.localizedDescription)
            switch (error!.code) {
            case LAError.biometryNotEnrolled.rawValue:
                self.alert("터치 아이디가 등록되어 있지 않습니다.")
            case LAError.passcodeNotSet.rawValue:
                print("패스 코드가 설정되어 있지 않습니다.")
            default: // LAError.touchIDNotAvailable 포함
                print("터치 아이디를 사용할 수 없습니다.")
            }
        }
    }
    
    // 액세스 토큰 갱신 메서드
    func refresh() {
        self.indicatorView.startAnimating() // 로딩 시작
        
        // 1. 인증 헤더
        let tk = TokenUtils()
        let header = tk.getAuthoriazationHeader()
        
        // 2. 리프레시 토큰 전달 준비
        let refreshToken = tk.load("kr.co.rubypaper.MyMemory", account: "refreshToken")
        let param: Parameters = ["refresh_token" : refreshToken!]
        
        // 3. 호출 및 응답
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/refresh"
        let refresh = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header)
        refresh.responseJSON { res in
            self.indicatorView.stopAnimating()
            
            guard let jsonObject = try! res.result.get() as? NSDictionary else {
                self.alert("잘못된 응답입니다.")
                return
            }
            // 4. 응답 결과 처리
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 { // 성공 : 액세스 토큰이 갱신된 것
                // 4-1. 키 체인에 저장된 액세스 토큰 교체
                let accessToken = jsonObject["access_token"] as! String
                tk.save("kr.co.rubypaper.MyMemory", account: "accessToken", value: accessToken)
            } else { // 실패 : 액세스 토큰 만료
                self.alert("인증이 만료되었으므로 다시 로그인해야 한다.")
                // 4-2. 로그아웃 처리
                OperationQueue.main.addOperation() {
                    self.commonLogout(true)
                }
            }
        } // end of responseJSON closure
    } // end of func refresh()
    
    func commonLogout(_ isLogin: Bool = false) {
        // 1. 저장된 기존 개인 정보 & 키 체인 데이터를 삭제하여 로그아웃 상태로 전환
        let userInfo = UserInfoManager()
        userInfo.deviceLogout()
        
        // 2. 현재의 화면이 프로필 화면이라면 바로 UI를 갱신한다.
        self.tv.reloadData()
        self.profileImage.image = userInfo.profile
        self.drawBtn()
        
        // 3. 기본 로그인 창 실행 여부
        if isLogin {
            self.doLogin(self)
        }
    }
}
