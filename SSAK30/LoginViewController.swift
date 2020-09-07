//
//  LoginViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var kakaobutton: UIButton!
    @IBOutlet weak var naverbutton: UIButton!

    @IBOutlet weak var lblId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // 버튼 모양
        kakaobutton.layer.cornerRadius = 20
        naverbutton.layer.cornerRadius = 20
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnLogin(_ sender: UIButton) {
        if lblId.text! == "Seller" {
            self.performSegue(withIdentifier: "sgSeller", sender: nil)
        } else {
            self.performSegue(withIdentifier: "sgBuyer", sender: nil)
        }
        
    }
}
