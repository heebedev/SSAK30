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

class BDetailViewController: UIViewController, BDetailQueryModelProtocol, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, BDetailThirycashQueryModelProtocol {
    
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
    
    // 나의 떠리 캐시
    @IBOutlet weak var lbl_totalCash: UILabel!
   
    
    
    
    // 변수 //
    var receiveSellSeqno : String!  // test
    var receiveCanBuyMaxNum : Int!
    var receiveStoreSeqno : String?
    var receiveImageName : String?
    
    var feedItem: NSArray = NSArray()
    var thirycashFeedItem: NSArray = NSArray()
    
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
    let locationManager = CLLocationManager() // GPS의 위치 알려줌
    // 지도 위도경도 변환한거 받는 변수
    var getLatituteValue: Double?
    var getLongitudeValue: Double?
    
    // 떠리캐시 변수
    var myTotalCash: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // uSeqno 받아오기
        uSeqno = String(UserDefaults.standard.integer(forKey: "uSeqno"))
        //print(uSeqno)
        // Do any additional setup after loading the view.
        
        let queryModel = BDetailQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(sellSeqno: receiveSellSeqno)
        
        // 로그인한 떠리캐시 내역 받아오기
        let myThirycashQueryModel = BDetailThirycashQueryModel()
        myThirycashQueryModel.delegate = self
        myThirycashQueryModel.downloadItems(uSeqno: uSeqno) // 받아온 uSeqno
        
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
    
   
    func thirycashItemDownloaded(items:NSArray){
        thirycashFeedItem = items
        let itemThirycash: ThirycashDBModel = thirycashFeedItem[0] as! ThirycashDBModel
        
        //나의 떠리캐시
        lbl_totalCash.text = itemThirycash.totalCash ?? "0"
        print("나의 떠리캐시:", itemThirycash.totalCash!)
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
        
       
        
        // 이미지
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
        
//        imgStore.getData(maxSize: 1 * 1024 * 1024) {data, error in
//            if error != nil {
//                self.iv_sImage?.image = UIImage(named: "emptyImage.png")
//            } else {
//                self.iv_sImage?.image = UIImage(data: data!)
//            }
//        }
        
        let url = URL(string: "http://localhost:8080/ftp/\(item.sImage!)")! // 원래이름 ( tomcat 서버에 넣어놓음)
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                DispatchQueue.main.async {
                    self.iv_sImage?.image = UIImage(data: data!)
                    // jpg
                    if let image = UIImage(data: data!){
                        if let data = image.jpegData(compressionQuality: 0.8){// 일반적으로 80% 압축
                            let filename = self.getDecumentDirectory().appendingPathComponent("recent.jpg") // 다운받을때 이미지이름 설정(동일한이름 들어가면 1,2 로변함)
                            try? data.write(to: filename)
                            print("Data is writed")

                        }
                    }

                    // png 쓸 때 사용
                    if let image = UIImage(data: data!){
                        if let data = image.pngData() {//
                            let filename = self.getDecumentDirectory().appendingPathComponent("recent.jpg") // // 다운받을때 이미지이름
                            try? data.write(to: filename)
                            print("Data is writed")


                        }
                    }
                }
            }
        }
        task.resume() // task 실행
        
        
        
        
        // 지도
        // 주소를 위도/경도로 변환
        let geocoder = CLGeocoder()
        let address = "\(item.sAddress!)"
        //print("받은주소: ",address)
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("주소 Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                // 위/경도 받아서
                self.getLatituteValue = Double(coordinates.latitude)
                self.getLongitudeValue = Double(coordinates.longitude)
                //print("Lat: \(self.getLatituteValue!) -- Long: \(self.getLongitudeValue!)")
                
                // 지도에 찍어!
                self.setAnnotation(latituteValue: self.getLatituteValue!, longitudeValue: self.getLongitudeValue!, delta: 0.01, title: "\(item.sName!)", subTitle: "")
                
            }
        })
        
    }
    
    // write 위치 (스마트폰의)
    func getDecumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0] // 첫번째 값 앱에 설정한 것의 위치
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
        // insert buylist 변수
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
        
        // 기존 떠리캐시
        self.myTotalCash = Int(self.lbl_totalCash.text!)!
        print("내 토탈캐시:", self.lbl_totalCash.text!)
        // 구매금액 계산
        let usePrice = Int(self.lbl_priceEA.text!)! * Int(self.selectedProductCount)! //구매금액
        
        // 기존 떠리캐시보다 구매금액이 적을때 못사게함
        if self.myTotalCash! < usePrice {
            let resultAlert = UIAlertController(title: "잔액부족", message: "떠리캐시의 잔액이 부족합니다. 마이페이지에서 충전 후 구매해 주세요.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        }else{
        
        // update validation 1 -> 0
        // 구매하시겠습니까 확인 알럿
        let resultAlert = UIAlertController(title: "구매", message: "구매하시겠습니까?.", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "구매", style: UIAlertAction.Style.default, handler: {ACTION in
            
            
            self.myTotalCash! = self.myTotalCash! - usePrice //구매 후 캐시
            print("구매후 캐시: ", self.myTotalCash!)
            self.lbl_totalCash.text = String(self.myTotalCash!) // setText
            
            let useThiryCashQueryModel = BDetailUseThirycashUpdateInsertModel()
            useThiryCashQueryModel.UseThityCashItems(uSeqno: uSeqno!, totalCash: String(self.myTotalCash!), usePrice: String(usePrice))
            
            
            // insert buylist
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
                self.present(resultAlert, animated: true, completion: nil)
                
            }else{
                // 알럿 //
                let resultAlert = UIAlertController(title: "구매실패", message: "구매 중 에러가 발생 되었습니다.", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true, completion: nil)
            }
            
        })
        
        
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            resultAlert.addAction(cancelAction)
            present(resultAlert, animated: true, completion: nil)
    
        
        
    }
    
    }
    
    
   
    // 함수 //
    // 지도
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
    
   
    // 지도끝//////////////////////////////
    
    
    // 함수 //
    // collection 뷰에서 sellSeqno 넘겨 줌
    func receiveItems(_ sellSeqno:String, canBuyMaxNum: Int, sSeqno: String){
        receiveSellSeqno = sellSeqno
        receiveCanBuyMaxNum = canBuyMaxNum
        receiveStoreSeqno = sSeqno
       }
    
    
    
    // Picker View의 동작에 필요한 Delegate 추가
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
