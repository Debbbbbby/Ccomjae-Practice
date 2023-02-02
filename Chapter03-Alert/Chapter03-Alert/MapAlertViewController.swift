//
//  MapAlertViewController.swift
//  Chapter03-Alert
//
//  Created by Doyeon on 2023/02/02.
//

import UIKit
import MapKit

class MapAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 생성
        let alertBtn = UIButton(type: .system)
        
        // 버튼 속성 설정
        alertBtn.frame = CGRect(x: 0, y: 150, width: 100, height: 30)
        alertBtn.center.x = self.view.frame.width / 2
        alertBtn.setTitle("Map Alert", for: .normal)
        alertBtn.addTarget(self, action: #selector(mapAlert(_:)), for: .touchUpInside)
        
        self.view.addSubview(alertBtn)
    }
    
    @objc func mapAlert(_ sender: UIButton) {
        // 경고창 객체를 생성하고, OK 및 Cancel 버튼을 추가한다.
        let alert = UIAlertController(title: nil,
                                      message: "여기가 맞습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        // 콘텐츠 뷰 영역에 들어갈 뷰 컨트롤러를 생성하고, 알림창에 등록한다.
        let contentVC = UIViewController()
        
        // 뷰 컨트롤러에 맵킷 뷰를 추가한다.
        let mapkitView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentVC.view = mapkitView
        // --> 여기까지만 설정하면 대한민국이 통째로 보인다.
        
        contentVC.preferredContentSize.height = 200
        
        // 맵킷 추가 설정
        // 1) 위치 정보(위도, 경도) 설정
        let pos = CLLocationCoordinate2D(latitude: 37.514322, longitude: 126.894623)
        
        // 2) 지도에서 보여줄 넓이, 일종의 축척, 숫자가 작을수록 좁은 범위를 확대시켜서 보여준다.
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        // 3) 지도 영역을 정의
        let region = MKCoordinateRegion(center: pos, span: span)
        
        // 4) 지도 뷰에 표시
        mapkitView.region = region
        mapkitView.regionThatFits(region)
        
        // 5) 위치를 핀으로 표시
        let point = MKPointAnnotation()
        point.coordinate = pos
        mapkitView.addAnnotation(point)
        
        
        // 뷰 컨트롤러를 알림창의 콘텐츠 뷰 컨트롤러 속성에 등록한다.
        alert.setValue(contentVC, forKey: "contentViewController")
        
        self.present(alert, animated: false)
        
    }

}
