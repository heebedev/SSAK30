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
    @IBOutlet weak var openPickerHour: UIPickerView!
    @IBOutlet weak var openPickerMinute: UIPickerView!
    @IBOutlet weak var closePickerHour: UIPickerView!
    @IBOutlet weak var closePickerMinute: UIPickerView!
    
    let imagePickerController = UIImagePickerController()
    let MAX_ARRAY_NUM = 24
    let PICKER_VIEW_COLUMN = 1
    var openHour = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    var openMinute = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]
    var closeHour = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    var closeMinute = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]

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
        
        let storeInsertModel = StoreInsertModel()
        let result = storeInsertModel.storeInsertItems(storeName: storeName!, businessNo: businessNo!, phone: phone!, address: address!)
        
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
