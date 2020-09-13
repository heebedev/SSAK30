//
//  SignUpViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, EmailChkModelProtocol{
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfChkPassword: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirth: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    var emailCheckResult: Int = 1
    var buySellNo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfPassword.isEnabled = false
        tfChkPassword.isEnabled = false
        tfName.isEnabled = false
        tfBirth.isEnabled = false
        tfPhone.isEnabled = false
        // Do any additional setup after loading the view.
        
    }
    
    
    //중복확인
    @IBAction func btnChkEmail(_ sender: UIButton) {
        let email = tfEmail.text!
        
        if isValidEmail(emailStr: email){
            let emailchk = EmailChkModel()
            emailchk.delegate = self
            emailchk.EmailChkloadItems(uEmail: email)
            
        }else{
            myAlert(alertTitle: "오류", alertMessage: "이메일 형식으로 입력해주세요.", actionTitle: "OK", handler: nil)
        }
        
        
    }
    
    func itemDownloaded(item: Int) {
        emailCheckResult = item
        
        if emailCheckResult == 0 {
            print("emailCheckResult \(emailCheckResult)")
            myAlert(alertTitle: "확인", alertMessage: "사용가능한 이메일입니다.", actionTitle: "OK", handler: nil)
            tfPassword.isEnabled = true
            tfChkPassword.isEnabled = true
            tfName.isEnabled = true
            tfBirth.isEnabled = true
            tfPhone.isEnabled = true
        } else {
            print("emailCheckResult \(emailCheckResult)")
            myAlert(alertTitle: "이메일 중복", alertMessage: "이미 사용중인 이메일입니다.", actionTitle: "OK", handler: nil)
        }
    }
    
    
    //가입하기
    @IBAction func btnSignUp(_ sender: UIButton) {
        
        let email = tfEmail.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        let password = tfPassword.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        let chkpassword = tfChkPassword.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        let name = tfName!.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        let birth = tfBirth!.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        let phone = tfPhone!.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        
        
        if email.isEmpty {
            myAlert(alertTitle: "실패", alertMessage: "이메일을 입력해주세요.", actionTitle: "OK", handler: nil)
        } else if !isValidEmail(emailStr: email) {
            myAlert(alertTitle: "실패", alertMessage: "이메일 형식으로 입력해주세요.", actionTitle: "OK", handler: nil)
        } else if emailCheckResult == 1 {
            myAlert(alertTitle: "실패", alertMessage: "이메일 중복확인을 해주세요.", actionTitle: "OK", handler: nil)
        } else {
            Check(password, chkpassword, name, birth, phone)
        }

        
        if validatePassword(password: password){
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
                let result = singupModel.SignUpInsertloadItems(uEmail: email, uPassword: password, uName: name, uBirth: birth, uPhone: phone, uBuySell: "\(self.buySellNo)")
                
                if result {
                    print("성공")
                }else{
                    print("실패")
                }
            })
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
            
            
            
        } else {
            let resultAlert = UIAlertController(title: "실패", message: "비밀번호가 일치하지 않습니다.", preferredStyle: UIAlertController.Style.alert)
            let  onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
        
        
        
    }

    func Check(_ password:String, _ chkPassword:String,_ name:String, _ birth:String, _ phone:String){
        if password.isEmpty {
            myAlert(alertTitle: "확인", alertMessage: "비밀번호를 입력해주세요", actionTitle: "OK", handler: nil)
        } else if chkPassword.isEmpty {
            myAlert(alertTitle: "확인", alertMessage: "비밀번호를 재확인해주세요", actionTitle: "OK", handler: nil)
        } else if name.isEmpty {
            myAlert(alertTitle: "확인", alertMessage: "이름을 입력해주세요", actionTitle: "OK", handler: nil)
        } else if birth.isEmpty {
            myAlert(alertTitle: "확인", alertMessage: "생일을 입력해주세요", actionTitle: "OK", handler: nil)
        } else if phone.isEmpty {
            myAlert(alertTitle: "확인", alertMessage: "전화번호를 입력해주세요", actionTitle: "OK", handler: nil)
        } else {

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
