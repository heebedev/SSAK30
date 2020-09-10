//
//  SignUpViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfChkPassword: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirth: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    //중복확인
    @IBAction func btnChkEmail(_ sender: UIButton) {
        let email = tfEmail.text!
        
//        let emailchk = EmailChkModel()
//        let result = emailchk.EmailChkloadItems(uEmail: email!)
        

        if isValidEmail(emailStr: email){
            print("성공")
        }else{
            myAlert(alertTitle: "실패", alertMessage: "이메일 형식으로 입력해주세요.", actionTitle: "OK", handler: nil)
            print("실패")
        }
        
    }
    //가입하기
    @IBAction func btnSignUp(_ sender: UIButton) {
        let email = tfEmail.text
        let password = tfPassword.text
        let name = tfName.text
        let birth = tfBirth.text
        let phone = tfPhone.text
        
        Check()
        if isValidEmail(emailStr: email!){
            print("성공")
        }else{
            myAlert(alertTitle: "실패", alertMessage: "이메일 형식으로 입력해주세요.", actionTitle: "OK", handler: nil)
            print("실패")
        }
        
        if validatePassword(password: password!){
            print("성공")
        }else{
            myAlert(alertTitle: "실패", alertMessage: "최소 8글자이상, 대문자, 소문자, 숫자 조합으로 입력해주새요.", actionTitle: "OK", handler: nil)
            print("실패")
        }
        
        if tfChkPassword.text == tfPassword.text{
            let resultAlert = UIAlertController(title: "완료", message: "회원가입에 성공했습니다.", preferredStyle: UIAlertController.Style.alert)
            let  onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {Action in
                // 전화면으로 넘어가기위한것
                self.navigationController?.popViewController(animated: true)
                
                let singupModel = SignUpModel()
                let result = singupModel.SignUpInsertloadItems(uEmail: email!, uPassword: password!, uName: name!, uBirth: birth!, uPhone: phone!, uBuySell: "1")
                
                if result {
                    print("성공")
                }else{
                    print("실패")
                }
            })
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
            
            
            
        }else{
            let resultAlert = UIAlertController(title: "실패", message: "비밀번호가 일치하지 않습니다.", preferredStyle: UIAlertController.Style.alert)
            let  onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
        
    }


    func Check(){
        if let email = tfEmail.text {
            if email.isEmpty {
                myAlert(alertTitle: "실패", alertMessage: "이메일을 입력해주세요", actionTitle: "OK", handler: nil)
                // 알림: 텍스트필드가 비어있습니다!
            }else{
                // 타이틀 String이 지금 래핑이 풀려있고, 비어있지도 않고, 사용할 준비가 되었습니다
            }
        }
        if let name = tfName.text {
            if name.isEmpty {
                myAlert(alertTitle: "실패", alertMessage: "이름을 입력해주세요", actionTitle: "OK", handler: nil)
                // 알림: 텍스트필드가 비어있습니다!
            }else{
                // 타이틀 String이 지금 래핑이 풀려있고, 비어있지도 않고, 사용할 준비가 되었습니다
            }
        }
        if let password = tfPassword.text {
            if password.isEmpty {
                myAlert(alertTitle: "실패", alertMessage: "비밀번호를 입력해주세요", actionTitle: "OK", handler: nil)
                // 알림: 텍스트필드가 비어있습니다!
            }else{
                // 타이틀 String이 지금 래핑이 풀려있고, 비어있지도 않고, 사용할 준비가 되었습니다
            }
        }
        if let birth = tfBirth.text {
            if birth.isEmpty {
                myAlert(alertTitle: "실패", alertMessage: "생일을 입력해주세요", actionTitle: "OK", handler: nil)
                // 알림: 텍스트필드가 비어있습니다!
            }else{
                // 타이틀 String이 지금 래핑이 풀려있고, 비어있지도 않고, 사용할 준비가 되었습니다
            }
        }
        if let phone = tfPhone.text {
            if phone.isEmpty {
                myAlert(alertTitle: "실패", alertMessage: "전화번호를 입력해주세요", actionTitle: "OK", handler: nil)
                // 알림: 텍스트필드가 비어있습니다!
            }else{
                // 타이틀 String이 지금 래핑이 풀려있고, 비어있지도 않고, 사용할 준비가 되었습니다
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
    

    
    // 패스워드
    func validatePassword(password:String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,24}$"

        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
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
