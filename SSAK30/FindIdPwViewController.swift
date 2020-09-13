//
//  FindIdPwViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/07.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class FindIdPwViewController: UIViewController, CheckFindIdPwModelProtocol {
    
    @IBOutlet weak var tfFindIdName: UITextField!
    @IBOutlet weak var tfFindIdBirth: UITextField!
    @IBOutlet weak var tfFindPwId: UITextField!
    @IBOutlet weak var tfFindPwName: UITextField!
    @IBOutlet weak var tfFindPwBirth: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnFindId(_ sender: UIButton) {
        let checkName = tfFindIdName.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        let checkBirth = tfFindIdBirth.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        
        if checkName.isEmpty || checkBirth.isEmpty {
            myAlert(alertTitle: "확인", alertMessage: "이름과 생년월일을 확인해주세요.", actionTitle: "OK", handler: nil)
        } else {
            let findId = CheckFindIdPwModel()
            findId.delegate = self
            findId.downloadItems(code: "findId", id : "", name: checkName, birth: checkBirth)
        }
        
    }
    
    @IBAction func btnChangePw(_ sender: UIButton) {
        let checkId = tfFindPwId.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        let checkName = tfFindPwName.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        let checkBirth = tfFindPwBirth.text!.trimmingCharacters(in: [" "]).replacingOccurrences(of: " ", with: "")
        
        if checkId.isEmpty || checkName.isEmpty || checkBirth.isEmpty {
            myAlert(alertTitle: "확인", alertMessage: "아이디, 이름, 생년월일을 확인해주세요.", actionTitle: "OK", handler: nil)
        } else {
            let findPw = CheckFindIdPwModel()
            findPw.delegate = self
            findPw.downloadItems(code: "findPw", id : checkId, name: checkName, birth: checkBirth)
        }
        
    }
    
    func itemDownloaded(code: String, item: String) {
        if code == "findId" {
            
        } else {
            
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
    
    func myAlert(alertTitle: String, alertMessage: String, actionTitle: String, handler:((UIAlertAction) -> Void)?) {
        let resultAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handler)
        resultAlert.addAction(onAction)
        present(resultAlert, animated: true, completion: nil)
    }

}
