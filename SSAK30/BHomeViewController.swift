//
//  BHomeViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class BHomeViewController: UIViewController {
    
    
    //collection view
     var interestRecommendListViewController: BMainRecommendListViewController!
    var recentRecommendListViewController: BMainRecentRecommendListViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // collectionview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "interest" {
            let destinationVC = segue.destination as? BMainRecommendListViewController
            interestRecommendListViewController = destinationVC
        }else if segue.identifier == "recent" {
            let destinationVC = segue.destination as? BMainRecentRecommendListViewController
            recentRecommendListViewController = destinationVC
            //interestRecommendListViewController.viewModel.updateType(.interest)
            //interestRecommendListViewController.viewModel.fetchItems()
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
 
