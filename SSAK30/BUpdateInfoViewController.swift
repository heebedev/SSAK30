//
//  BUpdateInfoViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class BUpdateInfoViewController: UIViewController {

    
    @IBOutlet weak var imgMyImage: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfNAme: UITextField!
    @IBOutlet weak var tfPasswordChk: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    var receiveuSeqno = ""
    var receiveEmail = ""
    var receiveName = ""
    var receivePassword = ""
    var receivePhone = ""
    var receiveImage = ""
    var uImage = "img"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tfEmail.text = String(receiveEmail)
        tfEmail.isUserInteractionEnabled = false // Read Only
        tfPassword.text = receivePassword
        tfPasswordChk.text = receivePassword
        tfNAme.text = receiveName
        tfPhone.text = receivePhone
    }
    
    func receiveItems(_ uSeqno:String, _ name: String, _ image: String, _ password: String, _ phone: String, _ email: String) {
        receiveuSeqno = uSeqno
        receiveName = name
        receiveImage = image
        receivePassword = password
        receivePhone = phone
        receiveEmail = email
    }

    @IBAction func btnUpdate(_ sender: UIButton) {
        let uName = tfNAme.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let uPassword = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let uPasswordChk = tfPasswordChk.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let uPhone = tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(uName == "" || uPassword == "" || uPhone == ""){
            let checkAlert = UIAlertController(title: "알림", message: "빈칸을 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            checkAlert.addAction(onAction)
            present(checkAlert, animated: true, completion: nil)
        }else if(uPassword != uPasswordChk) {
            let checkAlert = UIAlertController(title: "알림", message: "비밀번호가 일치하지 않습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            checkAlert.addAction(onAction)
            present(checkAlert, animated: true, completion: nil)
        }else{
        let queryModel = BUpdateQueryModel()
        queryModel.updateItem(uSeqno: receiveuSeqno , uName: uName!, uPassword: uPassword!, uPhone: uPhone!, uImage: uImage)
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

}
