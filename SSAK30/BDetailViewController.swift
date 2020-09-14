//
//  BDetailViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import MapKit // *** 추가
import Firebase // *** 추가

class BDetailViewController: UIViewController, BDetailQueryModelProtocol, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    // 아웃렛 연결 // // picker 구매갯수, 방문시간 제외
    @IBOutlet weak var iv_sbImage: UIImageView!
    @IBOutlet weak var lblMName: UILabel!
    @IBOutlet weak var lbl_sbTitle: UILabel!
    @IBOutlet weak var lbl_priceEA: UILabel!
    @IBOutlet weak var tv_sbContent: UITextView!
    @IBOutlet weak var lbl_sum_buyEA: UILabel!
    @IBOutlet weak var lbl_totalEA: UILabel!
    @IBOutlet weak var lbl_minimumEA: UILabel!
    @IBOutlet weak var lbl_openDate: UILabel!
    @IBOutlet weak var lbl_closeDate: UILabel!
    @IBOutlet weak var lbl_sName: UILabel!
    @IBOutlet weak var lbl_sPhone: UILabel!
    @IBOutlet weak var lbl_sServiceTime: UILabel!
    @IBOutlet weak var lbl_sAddress: UILabel!
    @IBOutlet weak var iv_sImage: UIImageView!
    
    // 피커뷰 구매 갯수
    @IBOutlet weak var picker_buyCount: UIPickerView!
    
    // 맵
    @IBOutlet weak var map_store: MKMapView!
    
    
    // 변수 //
    var receiveSellSeqno : String!  // test
    var receiveCanBuyMaxNum : Int!
    var receiveStoreSeqno : String?
    var receiveImageName : String?
    
    var feedItem: NSArray = NSArray()
    
    // 피커뷰 구매갯수
    //var max_array_num : Int? // 1인 최소 구매 갯수
    let PICKER_VIEW_COLUMN = 1
    let PICKER_VIEW_HEIGHT:CGFloat = 40 // 피커뷰 사이사이 간격
    var selectBuyCount: [Int] = []  // 구매 가능갯수
    var remainBuyCount: Int?
    
    // 구매하기 변수
    var selectedProductCount = ""
    var pickupDateTime: String = ""
    
    
    // 지도
    let locationManager = CLLocationManager() // GPS 의 현재 위치 알려줌
    
    // 지도 위도경도 변환한거 받는 변수
    var getLatituteValue: Double?
    var getLongitudeValue: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // uSeqno
        uSeqno = String(UserDefaults.standard.integer(forKey: "uSeqno"))
        //print(uSeqno)
        // Do any additional setup after loading the view.
        
        let queryModel = BDetailQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(sellSeqno: receiveSellSeqno)
        
        // 피커뷰 구매갯수
        picker_buyCount.delegate = self
        picker_buyCount.dataSource = self
        // 잔여수량, 구매가능갯수
        
        for count in 1...receiveCanBuyMaxNum!{
            selectBuyCount.append(count)
        }
        print("구매가능갯수배열:", selectBuyCount)
        
        // 구매하기 기본값
        selectedProductCount = "1"
        
        
        // 매장 지도
        map_store.showsUserLocation = true
        
        

        
    }
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        let item: BHomeDBModel = feedItem[0] as! BHomeDBModel
        
        // 남은 갯수
        remainBuyCount = Int(item.tatalEA!)! - Int(item.sum_buyEA!)!
        print("받은팔린갯수:",item.sum_buyEA!)
        lblMName.text = item.mName
        lbl_sbTitle.text = item.sbTitle
        lbl_priceEA.text = item.priceEA
        tv_sbContent.text = item.sbContext
        lbl_sum_buyEA.text = String(remainBuyCount!)
        lbl_totalEA.text = item.tatalEA
        lbl_minimumEA.text = item.minimumEA
        lbl_openDate.text = item.openDate
        lbl_closeDate.text = item.closeDate
        lbl_sName.text = item.sName
        lbl_sPhone.text = item.sPhone
        lbl_sServiceTime.text = item.sServiceTime
        lbl_sAddress.text = item.sAddress
        
        // 이미지 ///////////////////////
        //Firbase 이미지 불러오기
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("sbImage").child(item.sbImage!)
        let imgStore = storageRef.child("sbImage").child(item.sImage!)
        
        imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
            if error != nil {
                self.iv_sbImage?.image = UIImage(named: "emptyImage.png")
            } else {
                self.iv_sbImage?.image = UIImage(data: data!)
            }
        }
        
        imgStore.getData(maxSize: 1 * 1024 * 1024) {data, error in
            if error != nil {
                self.iv_sImage?.image = UIImage(named: "emptyImage.png")
            } else {
                self.iv_sImage?.image = UIImage(data: data!)
            }
        }
        
        
        // 지도
        
        // 주소를 위도/경도로 변환
        let geocoder = CLGeocoder()
        let address = "\(item.sAddress!)"
        print("받은주소: ",address)
                geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil){
                        print("주소 Error", error ?? "")
                    }
                    if let placemark = placemarks?.first {
                        let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                        self.getLatituteValue = Double(coordinates.latitude)
                        self.getLongitudeValue = Double(coordinates.longitude)
                        print("Lat: \(self.getLatituteValue!) -- Long: \(self.getLongitudeValue!)")
                        self.setAnnotation(latituteValue: self.getLatituteValue!, longitudeValue: self.getLongitudeValue!, delta: 0.01, title: "\(item.sName!)", subTitle: "")
                        
                    }
                })
        
      
    }

    // 액션 //
    // 방문시간 선택
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm" //EEE : 요일 제외
        pickupDateTime = formatter.string(from: datePickerView.date)
        print(pickupDateTime)
    }
    // 구매버튼
    @IBAction func insertBuylist(_ sender: UIButton) {
        let getSellSeqno = receiveSellSeqno
        //print("receiveSellSeqno: ",receiveSellSeqno)
        let getStoreSeqno = receiveStoreSeqno
        //print("receiveStoreSeqno:", receiveStoreSeqno)
        let getUSeqno = uSeqno
        //print("uSeqno: ",uSeqno)
        let getBuyCount = String(selectedProductCount)
        //print("selectedProductCount: ", selectedProductCount)
        let getPickupDate = pickupDateTime
        //print(" pickupDateTime", pickupDateTime)
        
        
        let insertModel = InsertBuylistModel() // 인스턴스 생성
        let result = insertModel.InsertItems(sellSeqno: getSellSeqno!, sSeqno: getStoreSeqno!, uSeqno: getUSeqno!, buyCount: getBuyCount, pickupDate: getPickupDate)// result Bool 받아와서 쓰기위해
        print(result)
        
        if result{
            // 알럿 //
            let resultAlert = UIAlertController(title: "구매완료", message: "구매가 완료 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)

        }else{
            // 알럿 //
            let resultAlert = UIAlertController(title: "구매실패", message: "구매 중 에러가 발생 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
    
    }
    
    
    // 지도 //
    // 함수 //
    // 위도와 경도에 대한 함수: 원하는 위도, 경도의 지도 띄우기
    //              latitudeValue 위도,                longituedValue: 경도,               delta : 확대/축소
    func goLocation(latitudeValue: CLLocationDegrees, longituedValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D{
        // GPS 로부터 좌표값을 받아옴
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longituedValue) //핀
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span) //확대
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        map_store.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    
    
    // 위치가 업데이트 되었을 때 지도의 위치를 표시해 주는 함수
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let pLocation = locations.last
           _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longituedValue: (pLocation?.coordinate.longitude)!, delta: 0.01) // delta 0.01: 기존 지도의 100배 확대
           
           // 주소값 가져오기
           // CLGeocode:지역 코드 / reverseGeocodeLocation : 우리나라주소 미국과 거꾸로라서
//           CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {(placemarks, error) -> Void in
//               let pm = placemarks!.first
//               let country = pm!.country
//               var address: String = country!
//               if pm!.locality != nil{ // 지역주소 : 옛날주소
//                   address += " "
//                   address += pm!.locality!
//               }
//
//               if pm!.thoroughfare != nil{ // 도로명 주소
//                   address += " "
//                   address += pm!.thoroughfare!
//               }
//
//           })
          
        
           locationManager.stopUpdatingLocation() // 끝
           
       }
    
    
    
    // Pin 설치 함수
    func setAnnotation(latituteValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subTitle strSubTitle: String){
        
        let annotation  = MKPointAnnotation() // Pin 찍어줌
        annotation.coordinate = goLocation(latitudeValue: latituteValue, longituedValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        map_store.addAnnotation(annotation)
    }
    
   
    // // /// /////////////////////////
    
    
    
    
    
    // 함수 //
    // collection 뷰에서 sellSeqno 넘겨 줌
    func receiveItems(_ sellSeqno:String, canBuyMaxNum: Int, sSeqno: String){
        receiveSellSeqno = sellSeqno
        receiveCanBuyMaxNum = canBuyMaxNum
        receiveStoreSeqno = sSeqno
       }
    
    
    // Picker View의 동작에 필요한 Delegate 추가
    
    // 상속 //
    // number of columns to display : 몇개의 컬럼 보여줄거임?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    
    // number of rows in each component : 몇 줄 돌릴거임?
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print("피커뷰몇줄?", receiveCanBuyMaxNum!)
        return receiveCanBuyMaxNum!
        
    }
    
    // string of title in each component : 한 줄에 보여줄 문자( Picker title 정하기 ) : titleForRow
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(selectBuyCount[row]) + "개"
    }
    
    // 선택 되었을때 뭐함?? : didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedProductCount = String(selectBuyCount[row])
        print(selectedProductCount)
        
    
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
