//
//  MyinfoViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import Firebase

class SMyinfoViewController: UIViewController, SMyInfoQueryModelProtocol, SMyInfoReviewQueryModelProtocol, SMyInfoLikeQueryModelProtocol, SMyInfoSellQueryModelProtocol, SMyInfoSellListQueryModelProtocol, UITableViewDataSource, UITableViewDelegate {


    var feedItem: NSArray = NSArray()
    var feedItem2: NSArray = NSArray()

    var uSeqno: String = String(UserDefaults.standard.integer(forKey: "uSeqno"))
    
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
    @IBOutlet weak var btnAddStore: UIButton!
    @IBOutlet weak var btnUpdateStoreInfo: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            self.tabBarItem.image = UIImage(named: "store.png")
            self.reloadInputViews()
            
            //다 내가(tableViewController) 할거다 선언.
            self.tvSellList.delegate = self
            self.tvSellList.dataSource = self
            self.tvSellList.rowHeight = 115
            
            let queryModel = SMyInfoQueryModel()
            queryModel.delegate = self
            queryModel.downloadItems(uSeqno: uSeqno)
            
            let queryModel2 = SMyInfoReviewQueryModel()
            queryModel2.delegate = self
            queryModel2.downloadItems(uSeqno: uSeqno)

            let queryModel3 = SMyInfoLikeQueryModel()
            queryModel3.delegate = self
            queryModel3.downloadItems(uSeqno: uSeqno)
            
            let queryModel4 = SMyInfoSellQueryModel()
            queryModel4.delegate = self
            queryModel4.downloadItems(uSeqno: uSeqno)
            
            let queryModel5 = SMyInfoSellListQueryModel()
            queryModel5.delegate = self
            queryModel5.downloadItems(uSeqno: uSeqno)
            

        }
        

        func itemDownloaded(items: NSArray) {
            feedItem2 = items
            if(feedItem2.count != 0){
            btnAddStore.isHidden = true
            let item: SMyInfoDBModel = feedItem2[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
            
            //Firbase 이미지 불러오기
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imgRef = storageRef.child("sImage").child(item.sImage!)

            imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
                if error != nil {
                    self.imgStoreImage.image = UIImage(named: "emptyImage.png")
                } else {
                    self.imgStoreImage.image = UIImage(data: data!)
                }
            }
                
                
            lblName.text = (item.sName!)
            lblBusinessNo.text = (item.sBusinessNo!)
            lblPhone.text = (item.sPhone!)
            lblAddress.text = (item.sAddress!)
            lblServiceTime.text = (item.sServiceTime!)
    //            let storage = Storage.storage()
    //            let storageRef = storage.reference()
    //            print(item.sImage as Any)
    //            let imgRef = storageRef.child("sImage").child(item.sImage!)
    //
    //            imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
    //                if error != nil {
    //                    self.imgStoreImage?.image = UIImage(named: "emptyImage.png")
    //                } else {
    //                    self.imgStoreImage?.image = UIImage(data: data!)
    //                }
    //            }
            }else{
                lblName.isHidden = true
                btnUpdateStoreInfo.isHidden = true
            }

        }
        
        func gradeItemDownloaded(items: NSArray) {
            feedItem = items
            if(feedItem.count != 0){
            let item: SMyInfoDBModel = feedItem[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
            lblGrade.text = (item.rGrade!)
            lblTotalReview.text = (item.reviewCount!)
            }else{
                
            }
        }
        func likeItemDownloaded(items: NSArray) {
            feedItem = items
            let item: SMyInfoDBModel = feedItem[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
            lblTotalLike.text = (item.likeCount!)

        }
        
        func sellItemDownloaded(items: NSArray) {
            feedItem = items
            let item: SMyInfoDBModel = feedItem[0] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
            lblTotalSell.text = (item.sellCount!)
        }
        
        func sellListItemDownloaded(items: NSArray) {
            feedItem = items
            self.tvSellList.reloadData()
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
               // #warning Incomplete implementation, return the number of sections
               return 1
           }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            feedItem.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sellCell", for: indexPath) as! BMyInfoTableViewCell
            // Configure the cell...

            let item: SMyInfoDBModel = feedItem[indexPath.row] as! SMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
            //Firbase 이미지 불러오기
    //        let storage = Storage.storage()
    //        let storageRef = storage.reference()
    //        let imgRef = storageRef.child("sbImage").child(item.sbImage!)
    //
    //        imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
    //            if error != nil {
    //                cell.imgSImage.image = UIImage(named: "emptyImage.png")
    //            } else {
    //                cell.imgSImage.image = UIImage(data: data!)
    //            }
    //        }
            
            cell.lblSTitle.text = (item.sbTitle!)
            cell.lblSPrice.text = (item.priceEA!)
            //Firbase 이미지 불러오기
            let storage = Storage.storage()
            let storageRef = storage.reference()
            print(item.sbImage as Any)
            let imgRef = storageRef.child("sbImage").child(item.sbImage!)

            imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
                if error != nil {
                    cell.imgSImage.image = UIImage(named: "emptyImage.png")
                } else {
                    cell.imgSImage.image = UIImage(data: data!)
                }
            }

            return cell
        }
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
                if segue.identifier == "sgSUpdate"{
                    
                    let detailView = segue.destination as! SUpdateInfoViewController
                    
                    let item: SMyInfoDBModel = feedItem2[0] as! SMyInfoDBModel
                    
                    let sName = String(item.sName!)
                    let sImage = String(item.sImage!)
                    let sBusinessNo = String(item.sBusinessNo!)
                    let sPhone = String(item.sPhone!)
                    let sAddress = String(item.sAddress!)
                    let sServiceTime = String(item.sServiceTime!)
                    
                    detailView.receiveItems(uSeqno, sName, sImage, sBusinessNo, sPhone, sAddress, sServiceTime)
                }
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
