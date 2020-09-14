//
//  BInterestViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import Firebase

class BInterestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BInterestStoreQueryModelProtocol {
    

    @IBOutlet weak var listTableView: UITableView!
    
    
    var feedItem: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.image = UIImage(named: "heart.png")

        // Do any additional setup after loading the view.
        
        
        let queryModel = BInterestStoreQueryModel()
        // query 사용을 위한 delegate
        queryModel.delegate = self
        queryModel.downloadItems()
        // tableView 사용
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.rowHeight = 146
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func storeItemDownloaded(items: NSArray) {
        feedItem = items
        self.listTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItem.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath) as! BInterestTableViewCell
        // Configure the cell...
        let item: BInterestDBModel = feedItem[indexPath.row] as! BInterestDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
        cell.imgView.layer.borderWidth = 1
        cell.imgView.layer.borderColor = UIColor.clear.cgColor
        cell.imgView.clipsToBounds = true
        
        //Firbase 이미지 불러오기
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("sImage").child(item.sImage!)
        
        imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
            if error != nil {
                cell.imgView?.image = UIImage(named: "emptyImage.png")
            } else {
                cell.imgView?.image = UIImage(data: data!)
            }
        }
        
        cell.lblName.text = (item.sName!)
        
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
