//
//  SUpdateInfoViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class SUpdateInfoViewController: UIViewController {

    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBusinessNo: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfServiceTime: UITextField!
    
    var receiveuSeqno = ""
    var receiveName = ""
    var receiveBusiness = ""
    var receiveAddress = ""
    var receivePhone = ""
    var receiveImage = ""
    var receiveServiceTime = ""
    var sImage = "img"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tfName.text = receiveName
        tfBusinessNo.text = receiveBusiness
        tfPhone.text = receivePhone
        tfAddress.text = receiveAddress
        tfServiceTime.text = receiveServiceTime
    }
    
    func receiveItems(_ uSeqno:String, _ name: String, _ image: String, _ businessNo: String, _ phone: String, _ address: String, _ serviceTime: String) {
        receiveuSeqno = uSeqno
        receiveName = name
        receiveImage = image
        receiveBusiness = businessNo
        receivePhone = phone
        receiveAddress = address
        receiveServiceTime = serviceTime
    }

    @IBAction func btnUpdate(_ sender: UIButton) {
        let sName = tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sBusinessNo = tfBusinessNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPhone = tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sAddress = tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sServiceTime = tfServiceTime.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(sName == "" || sBusinessNo == "" || sPhone == "" || sAddress == "" || sServiceTime == ""){
            let checkAlert = UIAlertController(title: "알림", message: "빈칸을 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            checkAlert.addAction(onAction)
            present(checkAlert, animated: true, completion: nil)
        }else{
        let queryModel = SUpdateQueryModel()
        queryModel.updateItem(uSeqno:receiveuSeqno, sName:sName!, sBusinessNo:sBusinessNo!, sServiceTime:sServiceTime!, sAddress:sAddress!, sPhone:sPhone!, sImage:sImage)
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
