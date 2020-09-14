//
//  BSearchViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class BSearchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, StoreMarketQueryModelProtocol, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchMap: MKMapView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tvPopularList: UITableView!
    
    let locationManager = CLLocationManager()
    let queryModel = StoreMarketQueryModel()
    
    
    var nearStoreModel = [NearStoreModel]()
    var marketModel = [MarketModel]()
    var uLocation = CLLocationCoordinate2D()
    var centerLoc = CLLocationCoordinate2D()
    
    
    var count :Bool = true;
    var marketCount : Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.image = UIImage(named: "search.png")
        
        // 맵 작동을 감지하기 위한 delegate
        searchMap.delegate = self
        // query 사용을 위한 delegate
        queryModel.delegate = self
        
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
    
        // tableView 사용
        tvPopularList.delegate = self
        tvPopularList.dataSource = self
        tvPopularList.rowHeight = 82
        
    }
    
    func itemDownloaded(items: NSArray, purpose: String) {
        
        if items.count != 0 {
            switch purpose {
            case "nearStore":
                nearStoreModel = items as! [NearStoreModel]
                self.tvPopularList.reloadData()
            case "nearMarket":
                marketModel = items as! [MarketModel]
                if marketCount {
                    for item in marketModel {
                        let title = "\(item.mName!) (\(item.mIncludedSales!) 개)"
                        setAnnotation(latitudeValue: item.mLatitude!, longitudeValue: item.mLongitude!, delta: 0.01, title: title)
                    }
                    _ = goLocation(latitudeValue: (uLocation.latitude), longitudeValue: (uLocation.longitude), delta: 0.01)
                    marketCount = false
                } else {
                    for item in marketModel {
                        let title = "\(item.mName!) (\(item.mIncludedSales!) 개)"
                        setAnnotation(latitudeValue: item.mLatitude!, longitudeValue: item.mLongitude!, delta: 0.01, title: title)
                    }
                }
                
            default: break
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // n번째 섹션에 몇 개의 row가 존재하는지를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearStoreModel.count
    }

    // n번째 섹션의 m번째 row를 그리는데 필요한 셀을 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //withIdentifier: "myCell" 은 cell 선택하고 설정해놓은 identifier,            indexPath(내용 index)
        let cell = tableView.dequeueReusableCell(withIdentifier: "popStoreCell", for: indexPath) as! popStoreTableViewCell
        
        //Firbase 이미지 불러오기
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("sImage").child(nearStoreModel[indexPath.row].sImage!)
        
        imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
            if error != nil {
                cell.ivPopStoreImage.image = UIImage(named: "emptyImage.png")
            } else {
                cell.ivPopStoreImage.image = UIImage(data: data!)
            }
        }
        
        cell.lbPopStoreName.text = nearStoreModel[indexPath.row].sName!
        cell.lbPopStoreLike.text = String("♥︎ \(nearStoreModel[indexPath.row].sLiked!)")
        if nearStoreModel[indexPath.row].rctSellNameofStore != "null" {
            cell.lbPopStoreRctSell.text = nearStoreModel[indexPath.row].rctSellNameofStore!
        } else {
            cell.lbPopStoreRctSell.text = "현재 구매가능한 상품이 없습니다."
        }
        
        
        return cell
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if count {
            uLocation = locations.last!.coordinate as CLLocationCoordinate2D
            goLocation(latitudeValue: (uLocation.latitude), longitudeValue: (uLocation.longitude), delta: 0.01)
            haveNearMarket(latitude: uLocation.latitude, longitude: uLocation.longitude)
            haveNearStore(latitude: uLocation.latitude, longitude: uLocation.longitude)
            count = false
        } else {
            let pLocation = locations.last?.coordinate
            haveNearMarket(latitude: pLocation!.latitude, longitude: pLocation!.longitude)
        }
        locationManager.stopUpdatingLocation()
    }
    
    //위도와 경도에 대한 함수
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        searchMap.setRegion(pRegion, animated: true)
        //haveNearMarket(latitude: centerLoc.latitude, longitude: centerLoc.longitude)
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        centerLoc = mapView.centerCoordinate
        haveNearMarket(latitude: centerLoc.latitude, longitude: uLocation.longitude)
    }
    
    // 주변 시장 정보 불러오기
    func haveNearMarket(latitude: Double, longitude: Double) {
        queryModel.downloadItems(purpose: "nearMarket", latitude: latitude, longitude: longitude)
    }
    
    // 내 위치 주변 스토어 정보 불러오기
    func haveNearStore(latitude: Double, longitude: Double) {
        queryModel.downloadItems(purpose: "nearStore", latitude: latitude, longitude: longitude)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfSearch.text = ""
        self.tvPopularList.reloadData()
    }
    
    // Pin 설치
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String) {
        let annotation = MKPointAnnotation() // Pin
        
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        searchMap.addAnnotation(annotation)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "sgSearchItem"){
            let searchItem = tfSearch.text!
            let displayVC = segue.destination as! AfterSearchTableViewController
            displayVC.searchItem = searchItem
        }
        
    }
    
    
    @IBAction func btnSearch(_ sender: UIButton) {
        if tfSearch.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let emptyKeyinAlert = UIAlertController(title: "경고", message: "검색어를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let checkAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            
            emptyKeyinAlert.addAction(checkAction)
            present(emptyKeyinAlert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "sgSearchItem", sender: self)
        }
        
    }
    
    
}
