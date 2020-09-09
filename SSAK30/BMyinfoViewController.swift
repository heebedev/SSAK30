//
//  BMyinfoViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class BMyinfoViewController: UIViewController, BMyInfoQueryModelProtocol, BMyInfoBuyListQueryModelProtocol, UITableViewDataSource, UITableViewDelegate{


    var feedItem: NSArray = NSArray()
    var feedItem2: NSArray = NSArray()
    var uSeqno: String?
    
    @IBOutlet weak var imgUserImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var tvMyBuyList: UITableView!
    @IBOutlet weak var tvMyReviewList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 다 내가(tableViewController) 할거다 선언.
        self.tvMyBuyList.delegate = self
        self.tvMyBuyList.dataSource = self
        
        let queryModel = BMyInfoQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno ?? "1")
        
        let queryModel2 = BMyInfoBuyListQueryModel()
        queryModel2.delegate = self
        queryModel2.downloadItems(uSeqno: uSeqno ?? "1")

    }
    func itemDownloaded(items: NSArray) {
        feedItem = items
        let item: BMyInfoDBModel = feedItem[0] as! BMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        lblName.text = item.uName
        print(item.uImage as Any)
        lblCash.text = item.totalCash
    }
    func buyListitemDownloaded(items: NSArray) {
        feedItem2 = items
        self.tvMyBuyList.reloadData()
        }
    
    
    override func viewWillAppear(_ animated: Bool) { // 입력 후 DB 에서 다시 읽어들이기
        let queryModel = BMyInfoQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno ?? "1")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return feedItem2.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buyCell", for: indexPath)
        // Configure the cell...
        let item: BMyInfoDBModel = feedItem2[indexPath.row] as! BMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        cell.textLabel?.text = (item.sellTitle!)
        cell.detailTextLabel?.text = (item.priceEA!)
        return cell
    }
    
    @IBAction func btnUpdateMyInfo(_ sender: UIButton) {
        
    }
    
    @IBAction func btnChargeCash(_ sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}//------
