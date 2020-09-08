//
//  BHomeViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class BHomeViewController: UIViewController {
    
    var recentRecommendListViewController: BMainRecommendListViewController!
    var hotRecommendListViewController: BMainRecommendListViewController!
    var interestRecommendListViewController: BMainRecommendListViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recent" {
            let destinationVC = segue.destination as? BMainRecommendListViewController
            recentRecommendListViewController = destinationVC
            recentRecommendListViewController.viewModel.updateType(.recent)
            recentRecommendListViewController.viewModel.fetchItems()
        } else if segue.identifier == "hot" {
            let destinationVC = segue.destination as? BMainRecommendListViewController
            hotRecommendListViewController = destinationVC
            hotRecommendListViewController.viewModel.updateType(.hot)
            hotRecommendListViewController.viewModel.fetchItems()
        } else if segue.identifier == "interest" {
            let destinationVC = segue.destination as? BMainRecommendListViewController
            interestRecommendListViewController = destinationVC
            interestRecommendListViewController.viewModel.updateType(.interest)
            interestRecommendListViewController.viewModel.fetchItems()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
