//
//  BDetailViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class BDetailViewController: UIViewController, BDetailQueryModelProtocol, UICollectionViewDelegate {
    
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
    
    // 변수 //
    var receiveSellSeqno : String!  // test
    var feedItem: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let queryModel = BDetailQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(sellSeqno: receiveSellSeqno)

        
    }
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        let item: BHomeDBModel = feedItem[0] as! BHomeDBModel
        
        let buyEA = String(Int(item.tatalEA!)! - Int(item.sum_buyEA!)!)
           print(buyEA)
        
        //let calc = String(Int(item.tatalEA!)! - Int(sumEA)!)
       
        
        
        
        //print(remain_buyEA!)
        lblMName.text = item.mName
        lbl_sbTitle.text = item.sbTitle
        lbl_priceEA.text = item.priceEA
        tv_sbContent.text = item.sbContext
        lbl_sum_buyEA.text = String(Int(item.tatalEA!)! - Int(item.sum_buyEA!)!)
        lbl_totalEA.text = item.tatalEA
        lbl_minimumEA.text = item.minimumEA
        lbl_openDate.text = item.openDate
        lbl_closeDate.text = item.closeDate
        lbl_sName.text = item.sName
        lbl_sPhone.text = item.sPhone
        lbl_sServiceTime.text = item.sServiceTime
        lbl_sAddress.text = item.sAddress
        
        // 이미지 //
        
        // 구매하기 // 피커뷰, 피커데이트.
        // 구매갯수
        
        // 방문시간 선택
        
    }

    // collection 뷰에서 sellSeqno 넘겨 줌
    func receiveItems(_ sellSeqno:String){
           receiveSellSeqno = sellSeqno
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
