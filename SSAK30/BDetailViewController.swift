//
//  BDetailViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class BDetailViewController: UIViewController, BDetailQueryModelProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    
    // 변수 //
    var receiveSellSeqno : String!  // test
    var receiveCanBuyMaxNum : Int!
    var receiveStoreSeqno : String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        print("receiveSellSeqno: ",receiveSellSeqno)
        let getStoreSeqno = receiveStoreSeqno
        print("receiveStoreSeqno:", receiveStoreSeqno)
        let getUSeqno = uSeqno
        print("uSeqno: ",uSeqno)
        let getBuyCount = String(selectedProductCount)
        print("selectedProductCount: ", selectedProductCount)
        let getPickupDate = pickupDateTime
        print(" pickupDateTime", pickupDateTime)
        
        
        let insertModel = InsertBuylistModel() // 인스턴스 생성
        let result = insertModel.InsertItems(sellSeqno: getSellSeqno!, sSeqno: getStoreSeqno!, uSeqno: getUSeqno!, buyCount: getBuyCount, pickupDate: getPickupDate)// result Bool 받아와서 쓰기위해
        print(result)
        
        if result{
            // 알럿 //
            let resultAlert = UIAlertController(title: "완료", message: "입력 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)

        }else{
            // 알럿 //
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
    
    }
    
    
    
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
