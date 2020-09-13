//
//  BuySellChkViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
//var BuySeller = 0
class BuySellChkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnBuy(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSell(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "sgSell"){
            let displayVC = segue.destination as! SignUpViewController
            displayVC.buySellNo = 1
        }
    }
    

}
