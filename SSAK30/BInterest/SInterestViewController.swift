//
//  InterestViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import Firebase

class SInterestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SInterestQueryModelProtocol, SInterestVIPQueryModelProtocol {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    var feedItem: NSArray = NSArray()
    var bName:String?
    var bPrice:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.image = UIImage(named: "heart.png")
        // Do any additional setup after loading the view.
        
        let queryModel = SInterestQueryModel()
        let queryModel2 = SInterestVIPQueryModel()
        // query 사용을 위한 delegate
        queryModel.delegate = self
        queryModel.downloadItems()
        
        queryModel2.delegate = self
        queryModel2.vipDownloadItems()
        // tableView 사용
        listTableView.delegate = self
        listTableView.dataSource = self
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func reviewItemDownloaded(items: NSArray) {
        feedItem = items
        self.listTableView.reloadData()
    }
    
    func vipItemDownloaded(bName: String, bPrice: String) {
        self.bName = bName
        self.bPrice = bPrice
        
        lblName.text = bName
        lblPrice.text = bPrice
        
        self.listTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItem.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SinterestCell", for: indexPath)

        // Configure the cell...
        let item: SInterestDBModel = feedItem[indexPath.row] as! SInterestDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let imgRef = storageRef.child("uImage").child(item.!)
//
//        imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
//            if error != nil {
//                self.imgUserImage.image = UIImage(named: "emptyImage.png")
//            } else {
//                self.imgUserImage.image = UIImage(data: data!)
//            }
        
        cell.textLabel?.text = "제목 : \(item.rTitle!)"
        cell.detailTextLabel?.text = "내용 : \(item.rContent!)"
        
        return cell
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
