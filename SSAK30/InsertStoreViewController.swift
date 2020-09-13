//
//  InsertStoreViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/11.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class InsertStoreViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var tfStoreName: UITextField!
    @IBOutlet weak var tfBusinessNo: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    
    let imagePickerController = UIImagePickerController()
    var openTime: String = ""
    var closeTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
    }
    
    // 사진 올리기 버튼
    @IBAction func btnAlbum(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // 매장 등록 버튼
    @IBAction func btnStoreInsert(_ sender: UIButton) {
        let storeName = tfStoreName.text
        let businessNo = tfBusinessNo.text
        let phone = tfPhone.text
        let address = tfAddress.text
        let serviceTime = openTime + " ~ " + closeTime
        
        let storeInsertModel = StoreInsertModel()
        let result = storeInsertModel.storeInsertItems(storeName: storeName!, businessNo: businessNo!, phone: phone!, address: address!, serviceTime: serviceTime)
        
        if result{
            let resultAlert = UIAlertController(title: "완료", message: "매장이 등록되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }else{
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
    }
    
    // 취소 버튼
    @IBAction func btnCancel(_ sender: UIButton) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = image
        }
        
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        openTime = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func closeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        closeTime = formatter.string(from: datePickerView.date)
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
