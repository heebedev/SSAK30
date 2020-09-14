//
//  AfterSearchTableViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/09.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class AfterSearchTableViewController: UITableViewController, AfterSearchQueryModelProtocol {
    
    var searchItem: String = ""
    var feedItem:NSArray = NSArray()
    var afterSearchResultModel = [AfterSearchResultModel]()
    
    @IBOutlet var tvSearchResult: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(searchItem)
        
        self.tvSearchResult.delegate = self
        self.tvSearchResult.dataSource = self
        
        let queryModel = AfterSearchQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(searchItem : searchItem)
        
        tvSearchResult.rowHeight = 90
        print(searchItem)
    }

    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.tvSearchResult.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "afterSearchCell", for: indexPath) as! AfterSearchTableViewCell

        let item: AfterSearchResultModel = feedItem[indexPath.row] as! AfterSearchResultModel
        
        if feedItem.count == 0 {
            cell.lbSerchResultsName?.text = "검색 결과가 없습니다."
        } else {
            cell.lbSerchResultsName?.text = "\(item.sName!) (\(item.mName!))"
            cell.lbSearchResultsbTitle?.text = item.sbTitle!
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tvSearchResult.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
