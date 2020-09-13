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
import KakaoSDKUser

class LoginViewController: UIViewController, KakaoLoginQueryModelProtocol, LoginModelProtocol {
    

    
    var userEmail:String?
    var uSeqno:String = ""
    var feedItem: NSArray = NSArray()
    
    var feedItems: NSArray = NSArray()
    var userPassword:String?
    var userSeqno: String = ""
    
    @IBOutlet weak var kakaobutton: UIButton!
    @IBOutlet weak var naverbutton: UIButton!

    @IBOutlet weak var lblId: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // 버튼 모양
        kakaobutton.layer.cornerRadius = 20
        naverbutton.layer.cornerRadius = 20
        self.reloadInputViews()
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
//        if lblId.text! == "Seller" {
//            self.performSegue(withIdentifier: "sgSeller", sender: nil)
//        } else {
//            self.performSegue(withIdentifier: "sgBuyer", sender: nil)
//        }
        
//        let email = lblId.text!
//        let password = tfPw.text!
//
//        if isValidEmail(emailStr: email){
//            let login = LoginModel()
//            login.delegate = self
//            login.downloadItems(uEmail: email, uPassword: password)
//        }else{
//            myAlert(alertTitle: "오류", alertMessage: "오류.", actionTitle: "OK", handler: nil)
//        }
        loginAction()
        
    }
    
    func loginAction() {
        self.userEmail = lblId.text
        self.userPassword = tfPw.text
        if(self.userEmail == nil || self.userEmail == ""){
            myAlert(alertTitle: "오류", alertMessage: "아이디 비밀번호를 확인해주세요.", actionTitle: "OK", handler: nil)
            
        }else{
        let queryModel = LoginModel()
            queryModel.delegate = self
            queryModel.downloadItems(uEmail: userEmail!, uPassword: userPassword!)
        }
    }
    

    
    func LoginitemDownloaded(items: NSArray) {
        feedItems = items
        let item: SingUpDBModel = feedItems[0] as! SingUpDBModel
        uSeqno = item.uSeqno!
        let uBuySell = item.uBuySell
        if(self.uSeqno == "0"){
            
        }else{
            if(uBuySell == "0"){
                self.performSegue(withIdentifier: "sgBuyer", sender: nil)
            }else{
                self.performSegue(withIdentifier: "sgSeller", sender: nil)
            }
            
        }
        
        
    }
    
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        let item: BMyInfoDBModel = feedItem[0] as! BMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        uSeqno = item.uSeqno!
        let uBuySell = item.uBuySell
        if(self.uSeqno == "0"){
            self.performSegue(withIdentifier: "sgSignUp", sender: nil)
        }else{
            if(uBuySell == "0"){
           self.performSegue(withIdentifier: "sgBuyer", sender: nil)
            }else{
                self.performSegue(withIdentifier: "sgSeller", sender: nil)
            }
        }
    }


    @IBAction func btnKakaoLogin(_ sender: UIButton) {
        kakaoLoginAction()
    }
    
    
    func kakaoLoginAction(){
            AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")

                //do something
                let _ = oauthToken
            }
            UserApi.shared.me() {(user, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("me() success.")
                    //do something
                    _ = user
                    self.userEmail = user?.kakaoAccount?.email
                    if(self.userEmail == nil || self.userEmail == ""){
                        
                    }else{
                    let queryModel = KakaoLoginQueryModel()
                    queryModel.delegate = self
                    queryModel.downloadItems(uEmail: self.userEmail!)

                    }
                    

                }
                
            }

        }
    }
    

    
    
    
    
    func myAlert(alertTitle: String, alertMessage: String, actionTitle: String, handler:((UIAlertAction) -> Void)?) {
        let resultAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handler)
        resultAlert.addAction(onAction)
        present(resultAlert, animated: true, completion: nil)
    }

    // 이메일
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}
