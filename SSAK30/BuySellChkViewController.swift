//
//  BuySellChkViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
var buySellNo = 0
class BuySellChkViewController: UIViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buySellNo = 0
    }
    
    
    @IBAction func btnBuy(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        print(buySellNo, "btnBuy")
    }
    
    
    @IBAction func btnSell(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        buySellNo = 1
        print(buySellNo, "btnsell")
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
