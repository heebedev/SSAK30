//
//  HomeViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class SHomeViewController: UIViewController {

    
    //collection view
    var sellingRecommendListViewController: SMainSellingRecommendListViewController!
    var doneSellRecommendListViewController: SMainDoneSellRecommendListViewController!
//    var DoneSellRecommendListViewController: SMainDoneSellRecommendListViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.image = UIImage(named: "home.png")

        // Do any additional setup after loading the view.
    }
    
    
    // collectionview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selling" {
            let destinationVC = segue.destination as? SMainSellingRecommendListViewController
            sellingRecommendListViewController = destinationVC
            
        }else if segue.identifier == "doneSell" {
        let destinationVC = segue.destination as? SMainDoneSellRecommendListViewController
        doneSellRecommendListViewController = destinationVC
        
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
