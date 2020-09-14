//
//  StoreDetailViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/14.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import Firebase

class StoreDetailViewController: UIViewController, SMyInfoQueryModelProtocol, SMyInfoReviewQueryModelProtocol, SMyInfoLikeQueryModelProtocol, SMyInfoSellQueryModelProtocol {
    
    
    @IBOutlet weak var ivStoreImage: UIImageView!
    @IBOutlet weak var lbStoreName: UILabel!
    @IBOutlet weak var lbStoreBusinessCode: UILabel!
    @IBOutlet weak var lbStoreTelno: UILabel!
    @IBOutlet weak var lbStoreAddress: UITextView!
    @IBOutlet weak var lbStoreOpenClose: UITextView!
    @IBOutlet weak var lbStoreGrade: UILabel!
    @IBOutlet weak var lbTotalReview: UILabel!
    @IBOutlet weak var lbTotalLike: UILabel!
    @IBOutlet weak var lbTotalSales: UILabel!
    
    var feedItem: NSArray = NSArray()
    var feedItem2: NSArray = NSArray()
    
    var receiveItem = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queryModel = SMyInfoQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: String(receiveItem))
        
        let queryModel2 = SMyInfoReviewQueryModel()
        queryModel2.delegate = self
        queryModel2.downloadItems(uSeqno: String(receiveItem))

        let queryModel3 = SMyInfoLikeQueryModel()
        queryModel3.delegate = self
        queryModel3.downloadItems(uSeqno: String(receiveItem))
        
        let queryModel4 = SMyInfoSellQueryModel()
        queryModel4.delegate = self
        queryModel4.downloadItems(uSeqno: String(receiveItem))
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func  receiveItems(_ item: Int) {
        receiveItem = item
    }
    
    func itemDownloaded(items: NSArray) {
        feedItem2 = items
        if(feedItem2.count != 0){
        let item: SMyInfoDBModel = feedItem2[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        
        //Firbase 이미지 불러오기
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("sImage").child(item.sImage!)
        
        imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
            if error != nil {
                self.ivStoreImage.image = UIImage(named: "emptyImage.png")
            } else {
                self.ivStoreImage.image = UIImage(data: data!)
            }
        }
            
            
        lbStoreName.text = (item.sName!)
        lbStoreBusinessCode.text = (item.sBusinessNo!)
        lbStoreTelno.text = (item.sPhone!)
        lbStoreAddress.text = (item.sAddress!)
        lbStoreOpenClose.text = (item.sServiceTime!)
        }

    }
    
    func gradeItemDownloaded(items: NSArray) {
        feedItem = items
        if(feedItem.count != 0){
        let item: SMyInfoDBModel = feedItem[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        lbStoreGrade.text = (item.rGrade!)
        lbTotalReview.text = (item.reviewCount!)
        } else {
            
        }
    }
    func likeItemDownloaded(items: NSArray) {
        feedItem = items
        let item: SMyInfoDBModel = feedItem[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        lbTotalLike.text = (item.likeCount!)

    }
    
    func sellItemDownloaded(items: NSArray) {
        feedItem = items
        let item: SMyInfoDBModel = feedItem[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        lbTotalSales.text = (item.sellCount!)
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
