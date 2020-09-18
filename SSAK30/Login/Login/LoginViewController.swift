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

class LoginViewController: UIViewController, KakaoLoginQueryModelProtocol, LoginModelProtocol{
    

    var userEmail:String?
    var uSeqno:String = ""
    var feedItem: NSArray = NSArray()
    
    var feedItems: NSArray = NSArray()
    var userPassword:String?

    @IBOutlet weak var kakaobutton: UIButton!

    @IBOutlet weak var lblId: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    
    var autoLogin = false
    var receiveuSeqno = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //******************* 혹시 uSeqno 정보가 남아있을 때 삭제.
        UserDefaults.standard.removeObject(forKey: "uSeqno")

        //******************* 버튼 모양
        kakaobutton.layer.cornerRadius = 20
        self.reloadInputViews()
    }
    
    func receiveItems(_ uSeqno:String) {
        receiveuSeqno = uSeqno
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
        loginAction()
    }
    
    func loginAction() {
        self.userEmail = lblId.text!
        self.userPassword = tfPw.text!
        if(self.userEmail == nil || self.userEmail == ""){
            myAlert(alertTitle: "오류", alertMessage: "아이디 비밀번호를 확인해주세요.", actionTitle: "OK", handler: nil)
        } else {
        let queryModel = LoginModel()
            queryModel.delegate = self
            queryModel.EmailloadItems(uEmail: userEmail!)
            
        }
    }

    
    func LoginChkDownloaded(uSeqno: String, uResult: String, uBuySellCode: String) {
        if uResult == "false" {
            myAlert(alertTitle: "확인", alertMessage: "등록되지 않은 정보입니다.", actionTitle: "OK", handler: nil)
        } else if uResult != tfPw.text! {
            myAlert(alertTitle: "비밀번호 오류", alertMessage: "비밀번호가 일치하지 않습니다.", actionTitle: "OK", handler: nil)
        } else {
            UserDefaults.standard.set(Int(uSeqno), forKey: "uSeqno")
            if uBuySellCode == "0" {
                self.performSegue(withIdentifier: "sgBuyer", sender: nil)
            } else {
                self.performSegue(withIdentifier: "sgSeller", sender: nil)
            }
        }
    }
    

    func itemDownloaded(items: NSArray) {
        feedItem = items
        let item: BMyInfoDBModel = feedItem[0] as! BMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        uSeqno = item.uSeqno!
        UserDefaults.standard.set(Int(uSeqno), forKey: "uSeqno")
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
    
    
    // ********************** KAKAO API LOGIN
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
    
    // ********************** 기본 ALERT
    func myAlert(alertTitle: String, alertMessage: String, actionTitle: String, handler:((UIAlertAction) -> Void)?) {
          let resultAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
          let onAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handler)
          resultAlert.addAction(onAction)
          present(resultAlert, animated: true, completion: nil)
      }

    // ********************** 이메일 CHECK
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }


}
