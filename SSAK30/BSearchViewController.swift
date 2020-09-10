//
//  BSearchViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import MapKit

class BSearchViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var searchMap: MKMapView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tvPopularList: UITableView!
    
    let locationManager = CLLocationManager()
    
    var items = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 위치데이터를 확인하기 위해 승인 요청
        locationManager.requestWhenInUseAuthorization()
        
        // 승인 완료 시 지도 보여주기
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // 사용자 현재 위치보기
        searchMap.showsUserLocation = true
        
        // 주변 지도 보이기
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // n번째 섹션에 몇 개의 row가 존재하는지를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // n번째 섹션의 m번째 row를 그리는데 필요한 셀을 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //withIdentifier: "myCell" 은 cell 선택하고 설정해놓은 identifier,            indexPath(내용 index)
         let cell = tableView.dequeueReusableCell(withIdentifier: "popStoreCell", for: indexPath) as! popStoreTableViewCell

         // Configure the cell...

         // item 세팅
//        cell.ivPopStoreImage.image = UIImage(named: items[(indexPath as NSIndexPath).row])
//        cell.lbPopStoreName.text = items[(indexPath as NSIndexPath).row]
        
         return cell
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        // delta:0.01 -> 기존 지도의 100배 확대
        
        //Handler 나오면 함수쓰라는 이야기야...
        locationManager.stopUpdatingLocation()
    }
    
    //위도와 경도에 대한 함수
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        searchMap.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    
    // Pin 설치
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subTitle strSubTitle: String) {
        
        let annotation = MKPointAnnotation() // Pin
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        searchMap.addAnnotation(annotation)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnSearch(_ sender: UIButton) {
        
    }
    
    

    
}
