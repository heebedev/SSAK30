//
//  SProductAddViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class SProductAddViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var tfSellTitle: UITextField!
    @IBOutlet weak var tfSellTotalEA: UITextField!
    @IBOutlet weak var tfSellMinimumEA: UITextField!
    @IBOutlet weak var tfSellPriceEA: UITextField!
    @IBOutlet weak var tvContext: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    
    var openDate:String = ""
    var closeDate:String = ""
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
    }
    
    @IBAction func btnAlbum(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func openDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
        openDate = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func closeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
        closeDate = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func btnRegist(_ sender: UIButton) {
        let title = tfSellTitle.text
        let totalEA = tfSellTotalEA.text
        let minimumEA = tfSellMinimumEA.text
        let priceEA = tfSellPriceEA.text
        let context = tvContext.text
        
        let productInsertModel = ProductInsertModel()
        let result = productInsertModel.productInsertItems(title: title!, totalEA: totalEA!, minimumEA: minimumEA!, priceEA: priceEA!, openDate: openDate, closeDate: closeDate, context: context!)
        
        if result{
            let resultAlert = UIAlertController(title: "완료", message: "상품이 등록되었습니다.", preferredStyle: UIAlertController.Style.alert)
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
