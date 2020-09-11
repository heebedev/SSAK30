//
//  LoginViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import KakaoAdSDK
import KakaoSDKCommon
import KakaoSDKAuth

class LoginViewController: UIViewController {
    
    
    
    
    
//    // 델리게이트와 프로토콜은 같이사용됨
//    var feedItem: NSArray = NSArray()
    
    @IBOutlet weak var kakaobutton: UIButton!
    @IBOutlet weak var naverbutton: UIButton!

    @IBOutlet weak var lblId: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    
    var autoLogin = false
    
    var receiveuSeqno = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // 버튼 모양
        kakaobutton.layer.cornerRadius = 20
        naverbutton.layer.cornerRadius = 20
        
//        let queryModel = SignUpModel()   // 인스턴스 생성
//        queryModel.delegate = self
//        queryModel.downloadItems()
        
    }
    
    
    func receiveItems(_ uSeqno:String) {
        receiveuSeqno = uSeqno
    }
    
    func loginWithStaticDatas(user_seq: Int) {
//       self.performSegue(withIdentifier: "sgLogin", sender: self)
        if lblId.text! == "Seller" {
            self.performSegue(withIdentifier: "sgSeller", sender: nil)
        } else {
            self.performSegue(withIdentifier: "sgBuyer", sender: nil)
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
    
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
//        if email == "Seller" {
//            self.performSegue(withIdentifier: "sgSeller", sender: nil)
//        } else {
//            self.performSegue(withIdentifier: "sgBuyer", sender: nil)
//        }
        
//        if  let email = lblId.text,
//            let password = tfPw.text {
//            let loginModel = SignUpModel()
//            loginModel.actionLogin(uEmail: email, uPassword: password) { resultSeq in
//                DispatchQueue.main.async { () -> Void in
//                    if resultSeq != 0 {
//                        if self.autoLogin {
////                            UserDefaults.standard.set(resultSeq, forKey: USER_DEFAULT_AUTO_LOGIN_SEQ)
//
//                        }
//                        self.loginWithStaticDatas(user_seq: resultSeq)
//                    } else {
//                        print(email)
//                        print(password)
//                    }
//                }
//            }
//        }
        if  let email = lblId.text,
            let password = tfPw.text {
            let loginModel = SignUpModel()
            loginModel.actionLogin(uSeqno: receiveuSeqno, uEmail: email, uPassword: password) { resultSeq in
                DispatchQueue.main.async { () -> Void in
                    if resultSeq != 0 {
                        if self.autoLogin {
                            //                            UserDefaults.standard.set(resultSeq, forKey: USER_DEFAULT_AUTO_LOGIN_SEQ)
                            
                        }
                        self.loginWithStaticDatas(user_seq: resultSeq)
                    } else {
                        
                    }
                }
            }
        }
        
        
        
        
    }
    
    
    
    @IBAction func btnKakaoLogin(_ sender: UIButton) {
        AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")

                //do something
                let _ = oauthToken
            }
        }
    }
}
