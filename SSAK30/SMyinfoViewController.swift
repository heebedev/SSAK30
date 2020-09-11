//
//  MyinfoViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class SMyinfoViewController: UIViewController, SMyInfoQueryModelProtocol, SMyInfoReviewQueryModelProtocol {

    var feedItem: NSArray = NSArray()
    var feedItem2: NSArray = NSArray()
    var uSeqno: String?
    
    @IBOutlet weak var imgStoreImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBusinessNo: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UITextView!
    @IBOutlet weak var lblServiceTime: UITextView!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblTotalReview: UILabel!
    @IBOutlet weak var lblTotalLike: UILabel!
    @IBOutlet weak var lblTotalSell: UILabel!
    @IBOutlet weak var tvSellList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 다 내가(tableViewController) 할거다 선언.
//        self.tvSellList.delegate = self
        
        let queryModel = SMyInfoQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno ?? "2")
        
        let queryModel2 = SMyInfoReviewQueryModel()
        queryModel2.delegate = self
        queryModel2.downloadItems(uSeqno: uSeqno ?? "1")

        queryModel2.delegate = self
        queryModel2.likeDownloadItems(uSeqno: uSeqno ?? "1")
    }
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        let item: SMyInfoDBModel = feedItem[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        lblName.text = item.sName
        print(item.sImage as Any)
        lblBusinessNo.text = item.sBusinessNo
        lblPhone.text = item.sPhone
        lblAddress.text = item.sAddress
        lblServiceTime.text = item.sServiceTime
    }
    
    func gradeItemDownloaded(items: NSArray) {
        feedItem2 = items
        let item: SMyInfoDBModel = feedItem2[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        lblGrade.text = item.rGrade
        lblTotalReview.text = item.reviewCount
        lblTotalLike.text = item.likeCount

    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    

    
    @IBAction func btnUpdateStoreInfo(_ sender: UIButton) {
        
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
